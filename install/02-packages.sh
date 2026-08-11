#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        02 - Core Packages                  │
# │        Install all required packages       │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Core Packages                 │
# ═════════════════════════════════════════════┘
CORE_PACKAGES=(
    # Base
    "base-devel"
    "git"
    "curl"
    "wget"
    "unzip"
    "zip"
    "rsync"
    "reflector"

    # Terminal
    "kitty"
    "zsh"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "fzf"
    "zoxide"
    "eza"
    "bat"
    "fd"
    "ripgrep"

    # Zsh Tools (functions & modules)
    "aria2"               # fastdownload function
    "ffmpeg"              # videoconvertmp3 function
    "yt-dlp"              # youtubedownload function
    "perl-image-exiftool" # fzf file preview (exiftool)
    "mediainfo"           # fzf media preview
    "nodejs"              # nvm module
    "npm"                 # nvm module

    # Window Manager
    "niri"
    "waybar"
    "rofi"
    "mako"
    "swayidle"
    "swaylock"
    "swaybg"
    "swww"

    # Audio
    "pipewire"
    "wireplumber"
    "pavucontrol"
    "pamixer"
    "playerctl"

    # Screenshot / Clipboard
    "grim"
    "slurp"
    "wl-clipboard"
    "cliphist"
    "satty"

    # Utilities
    "brightnessctl"
    "fastfetch"
    "jq"
    "tree"
    "less"
    "nano"
    "vim"
    "neovim"
    "htop"
    "btop"
    "dust"
    "bc"
    "pwgen"
)

# ═════════════════════════════════════════════┐
# │              Install Core Packages         │
# ═════════════════════════════════════════════┘
install_core_packages() {
    section "Core Packages"

    info "Installing ${#CORE_PACKAGES[@]} core packages..."

    # Install all core packages via pacman
    local missing=()
    for pkg in "${CORE_PACKAGES[@]}"; do
        if ! pkg_installed "$pkg"; then
            missing+=("$pkg")
        fi
    done

    if ((${#missing[@]} == 0)); then
        ok "All core packages already installed"
        return 0
    fi

    info "Installing missing packages: ${missing[*]}"
    run sudo pacman -S --needed --noconfirm "${missing[@]}"

    ok "Core packages installed"
}

# ═════════════════════════════════════════════┐
# │              Install AUR Packages          │
# ═════════════════════════════════════════════┘
install_aur_packages() {
    section "AUR Packages"

    # Ensure yay is available
    if ! have yay; then
        warn "yay not found, skipping AUR packages"
        return 0
    fi

    local aur_packages=(
        "walker-bin"
        "hyprpicker"
        "wlrctl"
        "impala"
        "rmpc"
    )

    info "Installing ${#aur_packages[@]} AUR packages..."

    local missing=()
    for pkg in "${aur_packages[@]}"; do
        if ! pkg_installed "$pkg"; then
            missing+=("$pkg")
        fi
    done

    if ((${#missing[@]} == 0)); then
        ok "All AUR packages already installed"
        return 0
    fi

    info "Installing missing AUR packages: ${missing[*]}"
    run yay -S --needed --noconfirm "${missing[@]}"

    ok "AUR packages installed"
}

# ═════════════════════════════════════════════┐
# │              Install From List             │
# ═════════════════════════════════════════════┘
install_from_list() {
    section "Packages from List"

    if [[ ! -f "$PACKAGES_FILE" ]]; then
        warn "Packages file not found: $PACKAGES_FILE"
        return 0
    fi

    info "Reading packages from $PACKAGES_FILE"

    # Read packages, strip comments, remove duplicates
    local packages=()
    while IFS= read -r line; do
        line="${line%%#*}"
        line="$(echo "$line" | xargs)"
        [[ -z "$line" ]] && continue

        local found=0
        for pkg in "${packages[@]}"; do
            if [[ "$pkg" == "$line" ]]; then
                found=1
                break
            fi
        done
        [[ $found -eq 0 ]] && packages+=("$line")
    done < "$PACKAGES_FILE"

    info "Installing ${#packages[@]} packages from list..."

    # Split into pacman and AUR
    local pacman_pkgs=()
    local aur_pkgs=()

    for pkg in "${packages[@]}"; do
        if pkg_installed "$pkg"; then
            continue
        fi
        if pacman -Si "$pkg" &>/dev/null; then
            pacman_pkgs+=("$pkg")
        else
            aur_pkgs+=("$pkg")
        fi
    done

    if ((${#pacman_pkgs[@]} > 0)); then
        info "Installing ${#pacman_pkgs[@]} pacman packages..."
        run sudo pacman -S --needed --noconfirm "${pacman_pkgs[@]}"
    fi

    if ((${#aur_pkgs[@]} > 0)); then
        if have yay; then
            info "Installing ${#aur_pkgs[@]} AUR packages..."
            run yay -S --needed --noconfirm "${aur_pkgs[@]}"
        else
            warn "yay not found, skipping AUR packages: ${aur_pkgs[*]}"
        fi
    fi

    ok "Packages from list installed"
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    install_core_packages
    install_aur_packages
    install_from_list
    ok "Package installation complete"
fi