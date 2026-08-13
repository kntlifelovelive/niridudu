#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        07 - Bluetooth                       │
# │        Setup only                          │
# │        Bluetooth packages are installed by │
# │        12-packages.sh (packages.txt)        │
# │        Enable/start bluetooth service      │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Enable Bluetooth              │
# │        Enable + start service (no install) │
# ═════════════════════════════════════════════┘
enable_bluetooth() {
	section "Bluetooth"

	if ! systemctl list-unit-files bluetooth.service &>/dev/null; then
		warn "bluetooth.service not found. It should be installed by 12-packages.sh."
		warn "Run 12-packages.sh first, then re-run this module."
		return 0
	fi

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
	enable_bluetooth
	ok "Bluetooth setup complete"
fi
