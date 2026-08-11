#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │ AuthorModify : KyawNyeinThant              │
# │ Github       : kntlifelovelive             │
# │ Date         : 2026 , March, 13            │
# │                                            │
# └────────────────────────────────────────────┘

# Photo Path Directories
# BG_DIR="$HOME/.config/hypr/hyprlockphotos/lockbackground/"
BG_DIR="$HOME/Pictures/wallpaper/"
HYPRLOCK_BG="$HOME/.cache/hyprlock_bg"

# Create cache folder if missing
mkdir -p "$(dirname "$HYPRLOCK_BG")"

# --- Rofi Menu Function ---
menu() {
  local DIR="$1"
  find "$DIR" -type f \( \
    -iname "*.jpg" -o \
    -iname "*.png" -o \
    -iname "*.jpeg" -o \
    -iname "*.webp" \
    \) | sort | while read -r img; do
    name="$(basename "$img")"
    printf "%s\x00icon\x1f%s\n" "$name" "$img"
  done
}

# --- Wallpaper Choice ---
choice="$(menu "$BG_DIR" | rofi \
  -show-icons \
  -i \
  -dmenu \
  -theme ~/.config/rofi/hrprlock/hyprlockWallpapers-bg.rasi \
  -p "Lock Background")"

[ -z "$choice" ] && exit 0

BG_PATH="$(find "$BG_DIR" -type f -iname "$choice" -print -quit)"
[ -z "$BG_PATH" ] && exit 0

# --- Auto create/update symlink cache ---
ln -sf "$BG_PATH" "$HYPRLOCK_BG"

# --- Reload hyprlock if active ---
if pgrep hyprlock >/dev/null; then
  pkill -USR1 hyprlock
fi

# Force exit code 0 to avoid red prompt
exit 0
