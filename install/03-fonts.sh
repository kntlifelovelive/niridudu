#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        03 - Fonts                           │
# │        Setup only                          │
# │        Font packages are installed by      │
# │        12-packages.sh (packages.txt)        │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Setup Fonts                    │
# │        Refresh font cache only (no install) │
# ═════════════════════════════════════════════┘
setup_fonts() {
	section "Fonts"

	info "Updating font cache..."
	run fc-cache -fv
	ok "Font cache updated"
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	setup_fonts
	ok "Font setup complete"
fi
