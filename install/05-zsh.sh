#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        05 - Zsh                            │
# │        zsh / plugin setup only             │
# │        zsh package is installed by         │
# │        12-packages.sh (packages.txt)       │
# │        NEVER modify existing zsh config    │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Setup Zsh                     │
# │        Install Oh My Zsh + plugins        │
# ═════════════════════════════════════════════┘
setup_zsh() {
	section "Zsh"

	# ── Check zsh ─────────────────────────────
	if ! have zsh; then
		warn "zsh not found. It should be installed by 12-packages.sh."
		warn "Run 12-packages.sh first, then re-run this module."
		return 0
	fi

	ok "zsh installed: $(zsh --version)"

	# ── Install Oh My Zsh ─────────────────────
	if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
		info "Installing Oh My Zsh..."

		run sh -c \
			"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
			"" --unattended

		ok "Oh My Zsh installed"
	else
		ok "Oh My Zsh already installed"
	fi

	# ── Plugin directory ──────────────────────
	local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
	local plugin_dir="$zsh_custom/plugins"

	mkdir -p "$plugin_dir"

	# ── Zsh plugins ───────────────────────────
	local plugins=(
		"zsh-autosuggestions|https://github.com/zsh-users/zsh-autosuggestions"
		"zsh-system-clipboard|https://github.com/kutsan/zsh-system-clipboard"
		"zsh-syntax-highlighting|https://github.com/zsh-users/zsh-syntax-highlighting"
	)

	for plugin in "${plugins[@]}"; do
		local name="${plugin%%|*}"
		local url="${plugin#*|}"
		local dest="$plugin_dir/$name"

		if [[ ! -d "$dest" ]]; then
			info "Installing plugin: $name"
			run git clone "$url" "$dest"
			ok "Installed: $name"
		else
			ok "Plugin already installed: $name"
		fi
	done

	# ── Set default shell ─────────────────────
	if [[ "$(basename "$SHELL")" != "zsh" ]]; then
		info "Setting default shell to zsh..."
		run chsh -s "$(command -v zsh)"
		ok "Default shell set to zsh"
	else
		ok "Default shell is already zsh"
	fi
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	setup_zsh
	ok "Zsh setup complete"
fi
