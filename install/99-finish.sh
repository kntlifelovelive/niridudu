#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        99 - Finish                         │
# │        Display actual installation state   │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════
# Package Summary
# ═════════════════════════════════════════════

display_package_summary() {
	section "Package Summary"

	if [[ ! -f "$PACKAGES_FILE" ]]; then
		warn "Packages file not found: $PACKAGES_FILE"
		return 0
	fi

	local packages=()

	mapfile -t packages < <(awk '
        {
            sub(/#.*/, "", $0)

            for (i = 1; i <= NF; i++) {
                if ($i != "")
                    print $i
            }
        }
    ' "$PACKAGES_FILE" | sort -u)

	local installed=0
	local missing=0

	echo -e "${C_CYAN}Installed packages:${C_RESET}"

	for pkg in "${packages[@]}"; do
		if pkg_installed "$pkg"; then
			ok "$pkg"
			((++installed))
		else
			warn "$pkg: NOT INSTALLED"
			((++missing))
		fi
	done

	echo ""

	if ((missing == 0)); then
		ok "All ${#packages[@]} packages are installed"
	else
		warn "$installed installed / $missing missing"
	fi
}

# ═════════════════════════════════════════════
# Service Summary
# ═════════════════════════════════════════════

display_service_summary() {
	section "Service Summary"

	local system_services=(
		"NetworkManager.service"
		"bluetooth.service"
	)

	local user_services=(
		"pipewire.service"
		"pipewire-pulse.service"
		"wireplumber.service"
	)

	# ── System Services ──────────────────────
	echo -e "${C_CYAN}System services:${C_RESET}"

	local system_enabled=0

	for service in "${system_services[@]}"; do
		if systemctl is-enabled --quiet "$service" 2>/dev/null; then
			ok "$service: enabled"
			((++system_enabled))
		else
			warn "$service: not enabled"
		fi
	done

	echo ""

	# ── User Services ────────────────────────
	echo -e "${C_CYAN}User services:${C_RESET}"

	local user_enabled=0

	for service in "${user_services[@]}"; do
		if systemctl --user is-enabled --quiet "$service" 2>/dev/null; then
			ok "$service: enabled"
			((++user_enabled))
		else
			warn "$service: not enabled"
		fi
	done

	echo ""

	info "Enabled system services: $system_enabled/${#system_services[@]}"
	info "Enabled user services: $user_enabled/${#user_services[@]}"
}

# ═════════════════════════════════════════════
# Config Summary
# ═════════════════════════════════════════════

display_config_summary() {
	section "Config Summary"

	local configs=(
		"niri"
		"waybar"
		"rofi"
		"kitty"
		"zsh"
	)

	local deployed=0
	local missing=0

	for config in "${configs[@]}"; do
		if [[ -e "$HOME_CONFIG/$config" ]]; then
			ok "~/.config/$config"
			((++deployed))
		else
			warn "Missing: ~/.config/$config"
			((++missing))
		fi
	done

	echo ""

	if [[ -f "$HOME/.zshenv" ]]; then
		ok "~/.zshenv"
	else
		warn "Missing: ~/.zshenv"
		((++missing))
	fi

	if [[ -d "$HOME_BIN" ]]; then
		local script_count

		script_count="$(
			find "$HOME_BIN" \
				-maxdepth 1 \
				-type f \
				-perm -u+x \
				2>/dev/null |
				wc -l
		)"

		ok "~/.local/bin: $script_count executable scripts"
	else
		warn "Missing: ~/.local/bin"
		((++missing))
	fi

	echo ""

	info "Config directories deployed: $deployed/${#configs[@]}"

	if ((missing > 0)); then
		warn "Missing config items: $missing"
	else
		ok "Config deployment looks complete"
	fi
}

# ═════════════════════════════════════════════
# Backup Summary
# ═════════════════════════════════════════════

display_backup_summary() {
	section "Backup Summary"

	if [[ -d "$BACKUP_DIR" ]]; then
		local backup_count

		backup_count="$(
			find "$BACKUP_DIR" \
				-mindepth 1 \
				-maxdepth 1 \
				2>/dev/null |
				wc -l
		)"

		ok "Backup directory: $BACKUP_DIR"
		info "Backup items: $backup_count"
	else
		info "No existing configuration needed backup."
		info "Backup directory was not created."
	fi
}

# ═════════════════════════════════════════════
# Final Summary
# ═════════════════════════════════════════════

display_summary() {
	section "Installation Summary"

	display_package_summary
	display_service_summary
	display_config_summary
	display_backup_summary

	echo ""
	echo -e "${C_GREEN}═══ Installation Complete ═══${C_RESET}"
	echo ""

	echo "  Next steps:"
	echo "    1. Log out and log back in (or reboot)"
	echo "    2. Start Niri session"
	echo "    3. Use 'theme-switch --rofi' to change themes"
	echo "    4. Use 'wallpaper --rofi' to change wallpapers"
	echo ""
}

# ═════════════════════════════════════════════
# Main
# ═════════════════════════════════════════════

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	display_summary
fi
