#!/usr/bin/env bash

set -o pipefail
set +e

# ┌────────────────────────────────────────────┐
# │      Packages Txtfile Check Variabl        │
# └────────────────────────────────────────────┘
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_LIST="$SCRIPT_DIR/../packages/packages.txt"

# ┌────────────────────────────────────────────┐
# │            Neon Typing Function            │
# └────────────────────────────────────────────┘
neo_type() {
  local color=$1
  local text="$2"
  local newline=${3:-yes}

  echo -ne "\033[${color}m"
  for ((i = 0; i < ${#text}; i++)); do
    printf "%s" "${text:$i:1}"
    sleep 0.02
  done

  if [[ "$newline" == "yes" ]]; then
    echo -e "\033[0m"
  else
    echo -ne "\033[0m"
  fi
}

[[ -f "$PKG_LIST" ]] || {
  echo "Package list not found!"
  exit 1
}

# ┌────────────────────────────────────────────┐
# │                  Yay Check                 │
# └────────────────────────────────────────────┘
if command -v yay >/dev/null 2>&1; then
  HAS_YAY=1
else
  HAS_YAY=0
fi

# ┌────────────────────────────────────────────┐
# │                Read packages               │
# └────────────────────────────────────────────┘
mapfile -t packages < <(grep -vE '^\s*#|^\s*$' "$PKG_LIST")

TOTAL=${#packages[@]}
COUNT=0

neo_type "1;35" "Starting package installation $TOTAL packages ..."

for pkg in "${packages[@]}"; do

  ((COUNT++))

  PERCENT=$((COUNT * 100 / TOTAL))

  echo
  neo_type "1;35" "[ $PERCENT% ] Processing $pkg"

  # ┌────────────────────────────────────────────┐
  # │          Already Installed Check           │
  # └────────────────────────────────────────────┘
  if pacman -Qi "$pkg" >/dev/null 2>&1; then
    neo_type "1;36" "Already Installed $pkg ✔"
    continue
  fi

  # ┌────────────────────────────────────────────┐
  # │             Check Official Repo            │
  # └────────────────────────────────────────────┘
  if pacman -Si "$pkg" >/dev/null 2>&1; then

    sudo pacman -S --needed --noconfirm "$pkg" >/dev/null 2>&1

    if [[ $? -eq 0 ]]; then
      neo_type "1;32" "Installed (pacman) $pkg ✔"
    else
      neo_type "1;31" "Pacman failed $pkg ✘"
    fi

  else
    if [[ $HAS_YAY -eq 1 ]]; then

      yay -S --needed --noconfirm "$pkg" >/dev/null 2>&1

      if [[ $? -eq 0 ]]; then
        neo_type "1;32" "Installed (AUR) $pkg ✔"
      else
        neo_type "1;31" "Yay failed $pkg ✘"
      fi

    else
      neo_type "1;33" "AUR package but yay missing — skipping"
    fi
  fi

done

echo
neo_type "1;35" "[ 100% ] Package installation complete"
