#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        01 - Yay AUR Helper                 │
# │        Install yay if not present          │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Install Yay                   │
# ═════════════════════════════════════════════┘
install_yay() {
	section "Yay AUR Helper"

	if have yay; then
		ok "yay already installed: $(yay --version | head -1)"
		return 0
	fi

	info "yay not found, installing..."

	# Install build dependencies
	install_pacman "git"
	install_pacman "base-devel"

	# Clone and build yay
	local tmp_dir="/tmp/yay-install"
	if [[ -d "$tmp_dir" ]]; then
		rm -rf "$tmp_dir"
	fi

	info "Cloning yay from AUR..."
	run git clone https://aur.archlinux.org/yay.git "$tmp_dir"

	info "Building and installing yay..."
	(
		cd "$tmp_dir"
		run makepkg -si --noconfirm
	)

	# Cleanup
	rm -rf "$tmp_dir"

	if have yay; then
		ok "yay installed successfully"
	else
		error "Failed to install yay"
	fi
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	install_yay
	ok "Yay setup complete"
fi
