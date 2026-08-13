#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        12 - Packages                      │
# │        Read packages.txt                   │
# │        ├── pacman packages                 │
# │        └── AUR packages                    │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════
# Read Packages
# ═════════════════════════════════════════════

read_packages() {
	if [[ ! -f "$PACKAGES_FILE" ]]; then
		error "Packages file not found: $PACKAGES_FILE"
	fi

	awk '
        {
            sub(/#.*/, "", $0)

            for (i = 1; i <= NF; i++) {
                if ($i != "")
                    print $i
            }
        }
    ' "$PACKAGES_FILE" | sort -u
}

# ═════════════════════════════════════════════
# Classify Package
# ═════════════════════════════════════════════
#
# official repo → pacman
# AUR           → aur
# nowhere       → unknown
#
# Never assume "not pacman" means AUR.

classify_package() {
	local pkg="$1"

	if pacman -Si "$pkg" &>/dev/null; then
		printf '%s\n' "pacman"
		return 0
	fi

	if have yay && yay -Si "$pkg" &>/dev/null; then
		printf '%s\n' "aur"
		return 0
	fi

	printf '%s\n' "unknown"
}

# ═════════════════════════════════════════════
# Install All Packages
# ═════════════════════════════════════════════

install_all_packages() {
	section "Packages from packages.txt"

	local packages=()

	mapfile -t packages < <(read_packages)

	local all_count="${#packages[@]}"

	info "Found $all_count unique packages in $PACKAGES_FILE"

	if ((all_count == 0)); then
		warn "No packages found in $PACKAGES_FILE"
		return 0
	fi

	# ── Package groups ────────────────────────
	local pacman_pkgs=()
	local aur_pkgs=()
	local unknown_pkgs=()

	local already=0

	# ── Classify ──────────────────────────────
	for pkg in "${packages[@]}"; do

		if pkg_installed "$pkg"; then
			((++already))
			continue
		fi

		local source

		source="$(classify_package "$pkg")"

		case "$source" in
		pacman)
			pacman_pkgs+=("$pkg")
			;;
		aur)
			aur_pkgs+=("$pkg")
			;;
		unknown)
			unknown_pkgs+=("$pkg")
			;;
		esac
	done

	info "Already installed: $already"
	info "To install: ${#pacman_pkgs[@]} pacman + ${#aur_pkgs[@]} AUR"

	# ══════════════════════════════════════════
	# Unknown Packages
	# ══════════════════════════════════════════

	if ((${#unknown_pkgs[@]} > 0)); then
		echo ""

		warn "Packages not found in official repos or AUR:"

		for pkg in "${unknown_pkgs[@]}"; do
			warn "  - $pkg"
		done

		error "Unknown package(s) found in $PACKAGES_FILE"
	fi

	# ══════════════════════════════════════════
	# Pacman Packages
	# ══════════════════════════════════════════

	if ((${#pacman_pkgs[@]} > 0)); then
		section "Pacman Packages"

		info "Installing ${#pacman_pkgs[@]} pacman packages..."

		run sudo pacman \
			-S \
			--needed \
			--noconfirm \
			"${pacman_pkgs[@]}"

		ok "Pacman packages installed"
	else
		ok "No pacman packages to install"
	fi

	# ══════════════════════════════════════════
	# AUR Packages
	# ══════════════════════════════════════════

	if ((${#aur_pkgs[@]} > 0)); then
		section "AUR Packages"

		if ! have yay; then
			error "yay is required for AUR packages."
		fi

		info "Installing ${#aur_pkgs[@]} AUR packages..."

		run yay \
			-S \
			--needed \
			--noconfirm \
			"${aur_pkgs[@]}"

		ok "AUR packages installed"
	else
		ok "No AUR packages to install"
	fi
}

# ═════════════════════════════════════════════
# Verify Installation
# ═════════════════════════════════════════════

verify_installation() {
	section "Verify Installation"

	local packages=()

	mapfile -t packages < <(read_packages)

	local failed=0
	local installed=0

	for pkg in "${packages[@]}"; do
		if pkg_installed "$pkg"; then
			ok "$pkg: installed"
			((++installed))
		else
			warn "$pkg: NOT installed"
			((++failed))
		fi
	done

	echo ""

	if ((failed == 0)); then
		ok "All ${#packages[@]} packages installed successfully"
	else
		warn "$failed package(s) failed to install"
		warn "$installed package(s) currently installed"
	fi
}

# ═════════════════════════════════════════════
# Main
# ═════════════════════════════════════════════

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	install_all_packages
	verify_installation

	ok "Packages installation complete"
fi
