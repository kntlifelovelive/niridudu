#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        09 - Wallpaper                      │
# │        Setup swww wallpaper system         │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Setup Wallpapers              │
# ═════════════════════════════════════════════┘
setup_wallpapers() {
    section "Wallpapers"

    # Ensure swww is installed
    if ! have swww; then
        info "Installing swww..."
        install_pacman "swww"
    else
        ok "swww already installed"
    fi

    # Create wallpaper directory
    local wallpaper_dir="$HOME/Pictures/wallpapers"
    mkdir -p "$wallpaper_dir"
    ok "Wallpaper directory: $wallpaper_dir"

    # Copy wallpapers from repo
    local repo_wallpapers="$CONFIG_DIR/wallpapers"
    if [[ -d "$repo_wallpapers" ]]; then
        local copied=0
        for img in "$repo_wallpapers"/*; do
            [[ -f "$img" ]] || continue
            local name
            name="$(basename "$img")"
            if [[ ! -f "$wallpaper_dir/$name" ]]; then
                run cp "$img" "$wallpaper_dir/"
                ((copied++))
            fi
        done
        ok "Copied $copied wallpapers"
    else
        warn "No wallpapers found in repo: $repo_wallpapers"
    fi

    # Check wallpaper count
    local count
    count="$(find "$wallpaper_dir" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) 2>/dev/null | wc -l)"
    ok "Found $count wallpapers"

    # Wallpaper script is deployed via config/local (10-config.sh)
    # Just ensure it's executable
    if [[ -x "$HOME_BIN/wallpaper" ]]; then
        ok "Wallpaper script ready at ~/.local/bin/wallpaper"
    else
        info "Wallpaper script will be available after config deployment"
    fi
}

# ═════════════════════════════════════════════┐
# │              Setup Rofi Integration        │
# ═════════════════════════════════════════════┘
setup_rofi_integration() {
    section "Rofi Wallpaper Integration"

    # Do NOT modify existing Rofi .rasi files
    # Just verify the wallpaper script can use the existing rasi
    local rofi_wallpaper_rasi="$HOME_CONFIG/rofi/wallpaper/wallpapers.rasi"
    if [[ -f "$rofi_wallpaper_rasi" ]]; then
        ok "Rofi wallpaper rasi found: $rofi_wallpaper_rasi"
    else
        warn "Rofi wallpaper rasi not found (will be available after rofi config deploy)"
    fi

    # Verify wallpaper script uses the existing rasi
    if [[ -f "$HOME_BIN/wallpaper" ]]; then
        if grep -q "wallpapers.rasi" "$HOME_BIN/wallpaper"; then
            ok "Wallpaper script uses existing Rofi rasi"
        else
            warn "Wallpaper script does not reference Rofi rasi"
        fi
    fi
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    setup_wallpapers
    setup_rofi_integration
    ok "Wallpaper setup complete"
fi