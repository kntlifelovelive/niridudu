#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        04 - Themes                          │
# │        Setup only                          │
# │        Theme packages are installed by     │
# │        12-packages.sh (packages.txt)        │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Setup Theme Structure         │
# ═════════════════════════════════════════════┘
setup_theme_structure() {
	section "Theme Structure"

	# Create theme config directory
	local themes_dest="$HOME_CONFIG/themes"
	mkdir -p "$themes_dest"

	# Copy themes from repo (NOT symlink)
	if [[ -d "$THEMES_DIR" ]]; then
		for theme in "$THEMES_DIR"/*; do
			[[ -d "$theme" ]] || continue
			local name
			name="$(basename "$theme")"
			local dest="$themes_dest/$name"

			if [[ -e "$dest" ]]; then
				rm -rf "$dest"
			fi
			run cp -r "$theme" "$dest"
			ok "Copied theme: $name"
		done
	fi

	# Create GTK config directories
	mkdir -p "$HOME_CONFIG/gtk-3.0"
	mkdir -p "$HOME_CONFIG/gtk-4.0"
	mkdir -p "$HOME/.icons/default"
	mkdir -p "$HOME_CONFIG/environment.d"

	ok "Theme structure created"
}

# ═════════════════════════════════════════════┐
# │              Apply Default Theme           │
# ═════════════════════════════════════════════┘
apply_default_theme() {
	section "Default Theme"

	# Apply tokyonight as default theme (deployed via config/local)
	if [[ -f "$HOME_BIN/globalthemeSwitcher" ]]; then
		info "Applying default theme (tokyonight)..."
		run bash "$HOME_BIN/globalthemeSwitcher" tokyonight
		ok "Default theme applied"
	else
		warn "globalthemeSwitcher not found, skipping"
	fi
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	setup_theme_structure
	apply_default_theme
	ok "Theme setup complete"
fi
