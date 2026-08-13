#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        11 - Audio Setup                    │
# │        Setup only                          │
# │        Audio packages are installed by     │
# │        12-packages.sh (packages.txt)        │
# │        Enable PipeWire + PipeWire-Pulse    │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Enable PipeWire Services      │
# │        Enable user services (no install)   │
# ═════════════════════════════════════════════┘
enable_pipewire_services() {
	section "PipeWire Services"

	# Enable user services
	local user_services=(
		"pipewire"
		"pipewire-pulse"
		"wireplumber"
	)

	for service in "${user_services[@]}"; do
		if systemctl --user list-unit-files "$service.service" &>/dev/null; then
			info "Enabling $service.service..."
			run systemctl --user enable "$service.service"
			ok "$service.service enabled"
		else
			warn "$service.service not found"
		fi
	done

	# Reload user daemon
	info "Reloading user systemd daemon..."
	run systemctl --user daemon-reload
	ok "User systemd daemon reloaded"
}

# ═════════════════════════════════════════════┐
# │              Verify Audio Setup            │
# ═════════════════════════════════════════════┘
verify_audio() {
	section "Audio Verification"

	# Check pipewire-pulse is enabled
	if systemctl --user is-enabled --quiet pipewire-pulse.service 2>/dev/null; then
		ok "pipewire-pulse.service: enabled"
	else
		warn "pipewire-pulse.service: not enabled"
	fi

	# Check wireplumber is enabled
	if systemctl --user is-enabled --quiet wireplumber.service 2>/dev/null; then
		ok "wireplumber.service: enabled"
	else
		warn "wireplumber.service: not enabled"
	fi

	# Check pipewire is enabled
	if systemctl --user is-enabled --quiet pipewire.service 2>/dev/null; then
		ok "pipewire.service: enabled"
	else
		warn "pipewire.service: not enabled"
	fi
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	enable_pipewire_services
	verify_audio
	ok "Audio setup complete"
fi
