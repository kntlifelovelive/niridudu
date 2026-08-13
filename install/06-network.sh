#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        06 - Network                        │
# │        Install and configure NetworkManager│
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Network Packages              │
# ═════════════════════════════════════════════┘
NETWORK_PACKAGES=(
	"networkmanager"
	"network-manager-applet"
)

# ═════════════════════════════════════════════┐
# │              Install Network               │
# ═════════════════════════════════════════════┘
install_network() {
	section "Network"

	info "Installing network packages..."
	install_packages "${NETWORK_PACKAGES[@]}"

	# Enable NetworkManager service
	info "Enabling NetworkManager.service..."
	run sudo systemctl enable NetworkManager.service
	ok "NetworkManager.service enabled"

	# Start if not running
	if ! systemctl is-active --quiet NetworkManager; then
		info "Starting NetworkManager.service..."
		run sudo systemctl start NetworkManager.service
		ok "NetworkManager.service started"
	else
		ok "NetworkManager.service already running"
	fi
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	install_network
	ok "Network setup complete"
fi
