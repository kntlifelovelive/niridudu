#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        08 - Niri                           │
# │        Setup / Validation only              │
# │        Niri package is installed by        │
# │        12-packages.sh                       │
# │        Niri config is deployed by          │
# │        10-config.sh                         │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Validate Niri Config          │
# ═════════════════════════════════════════════┘
validate_niri_config() {
	section "Niri Configuration"

	local niri_src="$CONFIG_DIR/niri"
	local niri_config="$niri_src/config.kdl"

	# Config source must exist in the repository.
	if [[ ! -f "$niri_config" ]]; then
		warn "Niri config not found: $niri_config"
		return 0
	fi

	ok "Niri config found: $niri_config"

	# Niri should already be installed by 12-packages.sh.
	if ! have niri; then
		warn "niri command not found."
		warn "Niri should be installed by 12-packages.sh."
		return 0
	fi

	info "Validating repository Niri config..."

	if niri validate -c "$niri_config" &>/dev/null; then
		ok "Niri config is valid"
	else
		warn "Niri config validation failed"
		warn "Check: $niri_config"
	fi
}

# ═════════════════════════════════════════════┐
# │              Verify Keybind Targets        │
# ═════════════════════════════════════════════┘
verify_keybind_targets() {
	section "Keybind Verification"

	local keybind_file="$CONFIG_DIR/niri/modules/keybind.kdl"

	if [[ ! -f "$keybind_file" ]]; then
		warn "Keybind config not found: $keybind_file"
		return 0
	fi

	info "Checking keybind targets..."

	local missing=()
	local found=0

	while IFS= read -r line; do
		# Skip comments and empty lines
		[[ "$line" =~ ^[[:space:]]*// ]] && continue
		[[ -z "${line//[[:space:]]/}" ]] && continue

		# Extract commands from spawn "command"
		if [[ "$line" =~ spawn[[:space:]]+\"([^\"]+)\" ]]; then
			local cmd="${BASH_REMATCH[1]}"

			# Commands handled outside ~/.local/bin verification.
			case "$cmd" in
			swaylock | makoctl | wpctl | playerctl | brightnessctl | walker | \
				ghostty | kitty | thunar | firefox | keepassxc | rmpc | hyprpicker | \
				niri | jq | sh)
				continue
				;;
			esac

			# Check normal PATH first, then ~/.local/bin.
			if command -v "$cmd" &>/dev/null || [[ -x "$HOME_BIN/$cmd" ]]; then
				((++found))
			else
				missing+=("$cmd")
			fi
		fi
	done <"$keybind_file"

	ok "Found $found keybind targets"

	if ((${#missing[@]} > 0)); then
		warn "Missing keybind targets:"

		for cmd in "${missing[@]}"; do
			warn "  - $cmd"
		done
	else
		ok "All keybind targets exist"
	fi
}

# ═════════════════════════════════════════════┐
# │              Main Niri Setup               │
# ═════════════════════════════════════════════┘
setup_niri() {
	validate_niri_config
	verify_keybind_targets

	ok "Niri setup complete"
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	setup_niri
fi
