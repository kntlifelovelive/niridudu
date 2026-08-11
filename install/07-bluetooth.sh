#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        07 - Bluetooth                      │
# │        Install and configure Bluetooth     │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Bluetooth Packages            │
# ═════════════════════════════════════════════┘
BLUETOOTH_PACKAGES=(
    "bluez"
    "bluez-utils"
    "blueman"
)

# ═════════════════════════════════════════════┐
# │              Install Bluetooth             │
# ═════════════════════════════════════════════┘
install_bluetooth() {
    section "Bluetooth"

    info "Installing bluetooth packages..."
    install_packages "${BLUETOOTH_PACKAGES[@]}"

    # Enable bluetooth service
    info "Enabling bluetooth.service..."
    run sudo systemctl enable bluetooth.service
    ok "bluetooth.service enabled"

    # Start if not running
    if ! systemctl is-active --quiet bluetooth; then
        info "Starting bluetooth.service..."
        run sudo systemctl start bluetooth.service
        ok "bluetooth.service started"
    else
        ok "bluetooth.service already running"
    fi
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    install_bluetooth
    ok "Bluetooth setup complete"
fi