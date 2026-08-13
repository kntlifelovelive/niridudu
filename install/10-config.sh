#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        10 - Config Deployment (FINAL)      │
# │        Deploy all user configuration       │
# │        Copy only - NEVER symlink            │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════
# Deploy Configs
# ═════════════════════════════════════════════

deploy_configs() {
	section "Config Deployment"

	if [[ ! -d "$CONFIG_DIR" ]]; then
		warn "Config directory not found: $CONFIG_DIR"
		return 0
	fi

	mkdir -p "$HOME_CONFIG"

	type_text " Deploying configurations... " 0.005 "$C_CYAN"
	type_spinner "Preparing config files" 1

	# ── Collect config items ──────────────────
	local items=()
	local item
	local name

	for item in "$CONFIG_DIR"/*; do
		[[ -e "$item" ]] || continue

		name="$(basename "$item")"

		# local is deployed separately.
		[[ "$name" == "local" ]] && continue

		items+=("$item")
	done

	local total="${#items[@]}"
	local deployed=0

	# ── Nothing to deploy ─────────────────────
	if ((total == 0)); then
		warn "No configuration directories found to deploy."
		return 0
	fi

	info "Found $total configuration items"

	# ── Deploy ────────────────────────────────
	for item in "${items[@]}"; do
		name="$(basename "$item")"

		local dest="$HOME_CONFIG/$name"

		# Backup existing config.
		if [[ -e "$dest" ]]; then
			backup_config "$dest"
			run rm -rf "$dest"
		fi

		# Copy - NOT symlink.
		run cp -r "$item" "$dest"

		((++deployed))

		show_progress "$deployed" "$total" "Configs"

		sleep 0.1
	done

	echo ""
	ok "Config deployment complete ($deployed/$total items copied)"
}

# ═════════════════════════════════════════════
# Deploy .zshenv
# ═════════════════════════════════════════════

deploy_zshenv() {
	section ".zshenv Deployment"

	local src="$REPO_ROOT/zshenv/.zshenv"

	if [[ ! -f "$src" ]]; then
		warn ".zshenv not found in repo: $src"
		return 0
	fi

	type_spinner "Deploying .zshenv" 1

	if [[ -f "$HOME/.zshenv" ]]; then
		backup_config "$HOME/.zshenv"
	fi

	run cp -f "$src" "$HOME/.zshenv"

	ok ".zshenv copied to $HOME/.zshenv"
}

# ═════════════════════════════════════════════
# Deploy Local Scripts
# ═════════════════════════════════════════════

deploy_local_scripts() {
	section "Local Scripts Deployment"

	local local_dir="$CONFIG_DIR/local"

	if [[ ! -d "$local_dir" ]]; then
		warn "Local scripts directory not found: $local_dir"
		return 0
	fi

	mkdir -p "$HOME_BIN"

	type_spinner "Deploying local scripts" 1

	# ── Collect scripts ───────────────────────
	local scripts=()
	local script

	for script in "$local_dir"/*; do
		[[ -f "$script" ]] || continue
		scripts+=("$script")
	done

	local total="${#scripts[@]}"
	local deployed=0

	if ((total == 0)); then
		warn "No local scripts found."
		return 0
	fi

	info "Found $total local scripts"

	# ── Deploy ────────────────────────────────
	for script in "${scripts[@]}"; do
		local name
		name="$(basename "$script")"

		run cp -f "$script" "$HOME_BIN/$name"
		run chmod +x "$HOME_BIN/$name"

		((++deployed))

		show_progress "$deployed" "$total" "Scripts"

		sleep 0.05
	done

	echo ""
	ok "Local scripts deployment complete ($deployed/$total scripts)"
}

# ═════════════════════════════════════════════
# Ensure PATH
# ═════════════════════════════════════════════

ensure_path() {
	section "PATH Configuration"

	mkdir -p "$HOME_CONFIG/environment.d"

	local path_conf="$HOME_CONFIG/environment.d/10-path.conf"

	if [[ ! -f "$path_conf" ]] ||
		! grep -qF "$HOME_BIN" "$path_conf" 2>/dev/null; then

		cat >"$path_conf" <<EOF
PATH=$HOME_BIN:\$PATH
EOF

		ok "PATH configured for ~/.local/bin"
	else
		ok "PATH already configured"
	fi
}

# ═════════════════════════════════════════════
# Ask Reboot
# ═════════════════════════════════════════════

ask_reboot() {
	echo ""
	echo -e "${C_GREEN}═══ All configurations deployed! ═══${C_RESET}"
	echo ""
	echo "  Backup location: $BACKUP_DIR"
	echo ""
	echo "  Next steps:"
	echo "    1. Log out and log back in (or reboot)"
	echo "    2. Start Niri session"
	echo "    3. Use 'theme-switch --rofi' to change themes"
	echo "    4. Use 'wallpaper --rofi' to change wallpapers"
	echo ""

	while true; do
		read -rp "Do you want to continue (c) or reboot (r)? [c/r]: " choice

		case "$choice" in
		[Cc]*)
			ok "Continuing without reboot"
			break
			;;
		[Rr]*)
			info "Rebooting now..."
			sudo reboot
			;;
		*)
			warn "Please enter c or r."
			;;
		esac
	done
}

# ═════════════════════════════════════════════
# Main
# ═════════════════════════════════════════════

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	deploy_configs
	deploy_zshenv
	deploy_local_scripts
	ensure_path

	ok "Config deployment complete"

	ask_reboot
fi
