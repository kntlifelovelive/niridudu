#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        99 - Finish                         │
# │        Display summary and final steps     │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Summary State                 │
# ═════════════════════════════════════════════┘
INSTALLED_PACKAGES=()
ENABLED_SERVICES=()
SKIPPED_ITEMS=()
WARNINGS=()

# ═════════════════════════════════════════════┐
# │              Display Summary               │
# ═════════════════════════════════════════════┘
display_summary() {
    section "Installation Summary"

    echo -e "${C_CYAN}═══ Installed Packages ═══${C_RESET}"
    if ((${#INSTALLED_PACKAGES[@]} > 0)); then
        for pkg in "${INSTALLED_PACKAGES[@]}"; do
            ok "$pkg"
        done
    else
        echo "  (none recorded)"
    fi

    echo ""
    echo -e "${C_CYAN}═══ Enabled Services ═══${C_RESET}"
    if ((${#ENABLED_SERVICES[@]} > 0)); then
        for svc in "${ENABLED_SERVICES[@]}"; do
            ok "$svc"
        done
    else
        echo "  (none recorded)"
    fi

    echo ""
    echo -e "${C_YELLOW}═══ Skipped Items ═══${C_RESET}"
    if ((${#SKIPPED_ITEMS[@]} > 0)); then
        for item in "${SKIPPED_ITEMS[@]}"; do
            warn "$item"
        done
    else
        echo "  (none)"
    fi

    echo ""
    echo -e "${C_YELLOW}═══ Warnings ═══${C_RESET}"
    if ((${#WARNINGS[@]} > 0)); then
        for warn_msg in "${WARNINGS[@]}"; do
            warn "$warn_msg"
        done
    else
        echo "  (none)"
    fi

    echo ""
    echo -e "${C_GREEN}═══ Installation Complete ═══${C_RESET}"
    echo ""
    echo "  Backup location: $BACKUP_DIR"
    echo ""
    echo "  Next steps:"
    echo "    1. Log out and log back in (or reboot)"
    echo "    2. Start Niri session"
    echo "    3. Use 'theme-switch --rofi' to change themes"
    echo "    4. Use 'wallpaper --rofi' to change wallpapers"
    echo ""
}

# ═════════════════════════════════════════════┐
# │              Ask for Reboot                │
# │        Optional (requires sudo)            │
# ═════════════════════════════════════════════┘
ask_reboot() {
    echo ""
    read -rp "Do you want to reboot now? (y/n, requires sudo): " choice

    case "$choice" in
        [Yy]*)
            info "Rebooting..."
            sudo reboot
            ;;
        [Nn]*)
            ok "Continuing without reboot"
            ;;
        *)
            warn "Invalid input, continuing without reboot"
            ;;
    esac
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    display_summary

    # Only ask for reboot if sudo is available
    if command -v sudo &>/dev/null; then
        ask_reboot
    else
        ok "sudo not available - skipping reboot prompt"
    fi
fi
