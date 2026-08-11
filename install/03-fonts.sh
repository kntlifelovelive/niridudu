#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        03 - Fonts                          │
# │        Install required fonts              │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Font Packages                 │
# ═════════════════════════════════════════════┘
FONT_PACKAGES=(
    "ttf-jetbrains-mono-nerd"
    "ttf-font-awesome"
    "noto-fonts"
    "noto-fonts-emoji"
    "noto-fonts-cjk"
    "ttf-nerd-fonts-symbols"
)

# ═════════════════════════════════════════════┐
# │              Install Fonts                 │
# ═════════════════════════════════════════════┘
install_fonts() {
    section "Fonts"

    info "Installing ${#FONT_PACKAGES[@]} font packages..."

    local missing=()
    for pkg in "${FONT_PACKAGES[@]}"; do
        if ! pkg_installed "$pkg"; then
            missing+=("$pkg")
        fi
    done

    if ((${#missing[@]} == 0)); then
        ok "All fonts already installed"
    else
        info "Installing missing fonts: ${missing[*]}"
        run sudo pacman -S --needed --noconfirm "${missing[@]}"
        ok "Fonts installed"
    fi

    # Update font cache
    info "Updating font cache..."
    run fc-cache -fv
    ok "Font cache updated"
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    install_fonts
    ok "Font setup complete"
fi