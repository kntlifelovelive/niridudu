#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        04 - Themes                         │
# │        Install GTK themes and setup        │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Theme Packages                │
# ═════════════════════════════════════════════┘
THEME_PACKAGES=(
    # GTK Themes
    "tokyonight-gtk-theme"
    "catppuccin-gtk-theme"
    "gruvbox-dark-gtk-theme"

    # Icon Themes
    "yaru-icon-theme"
    "papirus-icon-theme"

    # Cursor Themes
    "bibata-cursor-theme"
)

# ═════════════════════════════════════════════┐
# │              Install Theme Packages        │
# ═════════════════════════════════════════════┘
install_theme_packages() {
    section "Theme Packages"

    info "Installing ${#THEME_PACKAGES[@]} theme packages..."

    local missing=()
    for pkg in "${THEME_PACKAGES[@]}"; do
        if ! pkg_installed "$pkg"; then
            missing+=("$pkg")
        fi
    done

    if ((${#missing[@]} == 0)); then
        ok "All theme packages already installed"
        return 0
    fi

    # Split into pacman and AUR
    local pacman_pkgs=()
    local aur_pkgs=()

    for pkg in "${missing[@]}"; do
        if pacman -Si "$pkg" &>/dev/null; then
            pacman_pkgs+=("$pkg")
        else
            aur_pkgs+=("$pkg")
        fi
    done

    if ((${#pacman_pkgs[@]} > 0)); then
        info "Installing pacman theme packages..."
        run sudo pacman -S --needed --noconfirm "${pacman_pkgs[@]}"
    fi

    if ((${#aur_pkgs[@]} > 0)); then
        if have yay; then
            info "Installing AUR theme packages..."
            run yay -S --needed --noconfirm "${aur_pkgs[@]}"
        else
            warn "yay not found, skipping AUR theme packages: ${aur_pkgs[*]}"
        fi
    fi

    ok "Theme packages installed"
}

# ═════════════════════════════════════════════┐
# │              Setup Theme Structure         │
# ═════════════════════════════════════════════┘
setup_theme_structure() {
    section "Theme Structure"

    # Create theme config directory
    local themes_dest="$HOME_CONFIG/themes"
    mkdir -p "$themes_dest"

    # Copy themes from repo (NOT symlink)
    if [[ -d "$THEMES_DIR" ]]; then
        for theme in "$THEMES_DIR"/*; do
            [[ -d "$theme" ]] || continue
            local name
            name="$(basename "$theme")"
            local dest="$themes_dest/$name"

            if [[ -e "$dest" ]]; then
                rm -rf "$dest"
            fi
            run cp -r "$theme" "$dest"
            ok "Copied theme: $name"
        done
    fi

    # Create GTK config directories
    mkdir -p "$HOME_CONFIG/gtk-3.0"
    mkdir -p "$HOME_CONFIG/gtk-4.0"
    mkdir -p "$HOME/.icons/default"
    mkdir -p "$HOME_CONFIG/environment.d"

    ok "Theme structure created"
}

# ═════════════════════════════════════════════┐
# │              Apply Default Theme           │
# ═════════════════════════════════════════════┘
apply_default_theme() {
    section "Default Theme"

    # Apply tokyonight as default theme (deployed via config/local)
    if [[ -f "$HOME_BIN/globalthemeSwitcher" ]]; then
        info "Applying default theme (tokyonight)..."
        run bash "$HOME_BIN/globalthemeSwitcher" tokyonight
        ok "Default theme applied"
    else
        warn "globalthemeSwitcher not found, skipping"
    fi
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    install_theme_packages
    setup_theme_structure
    apply_default_theme
    ok "Theme setup complete"
fi