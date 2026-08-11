#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        08 - Niri                           │
# │        Install and configure Niri          │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Niri Packages                 │
# ═════════════════════════════════════════════┘
NIRI_PACKAGES=(
    "niri"
    "uwsm"
    "waybar"
    "mako"
    "swayidle"
    "swaylock"
    "grim"
    "slurp"
    "satty"
    "wl-clipboard"
    "cliphist"
    "brightnessctl"
    "playerctl"
    "pavucontrol"
    "pamixer"
    "rofi"
    "kitty"
    "ghostty"
    "fuzzel"
    "walker-bin"
    "hyprpicker"
    "wlrctl"
    "wev"
    "swww"
)

# ═════════════════════════════════════════════┐
# │              Install Niri Packages         │
# ═════════════════════════════════════════════┘
install_niri_packages() {
    section "Niri Packages"

    info "Installing ${#NIRI_PACKAGES[@]} Niri-related packages..."

    local missing=()
    for pkg in "${NIRI_PACKAGES[@]}"; do
        if ! pkg_installed "$pkg"; then
            missing+=("$pkg")
        fi
    done

    if ((${#missing[@]} == 0)); then
        ok "All Niri packages already installed"
        return 0
    fi

    # Split into pacman and AUR
    local pacman_pkgs=()
    local aur_pkgs=()

    for pkg in "${missing[@]}"; do
        if pacman -Si "$pkg" &>/dev/null; then
            pacman_pkgs+=("$pkg")
        else
            aur_pkgs+=("$pkg")
        fi
    done

    if ((${#pacman_pkgs[@]} > 0)); then
        info "Installing pacman Niri packages..."
        run sudo pacman -S --needed --noconfirm "${pacman_pkgs[@]}"
    fi

    if ((${#aur_pkgs[@]} > 0)); then
        if have yay; then
            info "Installing AUR Niri packages..."
            run yay -S --needed --noconfirm "${aur_pkgs[@]}"
        else
            warn "yay not found, skipping AUR packages: ${aur_pkgs[*]}"
        fi
    fi

    ok "Niri packages installed"
}

# ═════════════════════════════════════════════┐
# │              Deploy Niri Config            │
# ═════════════════════════════════════════════┘
deploy_niri_config() {
    section "Niri Configuration"

    local niri_src="$CONFIG_DIR/niri"
    local niri_dest="$HOME_CONFIG/niri"

    if [[ ! -d "$niri_src" ]]; then
        warn "Niri config not found in repo, skipping"
        return 0
    fi

    # Backup existing config
    if [[ -e "$niri_dest" ]]; then
        backup_config "$niri_dest"
        rm -rf "$niri_dest"
    fi

    # Copy (NOT symlink) the config
    run cp -r "$niri_src" "$niri_dest"
    ok "Niri config copied"

    # Validate config if niri is available
    if have niri; then
        info "Validating Niri config..."
        if niri validate -c "$niri_dest/config.kdl" &>/dev/null; then
            ok "Niri config valid"
        else
            warn "Niri config validation failed (may be due to missing commands)"
        fi
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

    # Extract all spawn commands from keybind config
    local missing=()
    local found=0

    while IFS= read -r line; do
        # Skip commented lines
        [[ "$line" =~ ^[[:space:]]*// ]] && continue

        # Extract spawn commands
        if [[ "$line" =~ spawn[[:space:]]+\"([^\"]+)\" ]]; then
            local cmd="${BASH_REMATCH[1]}"
            # Skip system commands
            case "$cmd" in
                swaylock|makoctl|wpctl|playerctl|brightnessctl|walker|ghostty|kitty|thunar|firefox|keepassxc|rmpc|hyprpicker|niri|jq|sh)
                    continue
                    ;;
            esac

            # Check if command exists in PATH or ~/.local/bin
            if command -v "$cmd" &>/dev/null || [[ -x "$HOME_BIN/$cmd" ]]; then
                ((found++))
            else
                missing+=("$cmd")
            fi
        fi
    done < "$keybind_file"

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
# │              Deploy Other Configs          │
# ═════════════════════════════════════════════┘
deploy_other_configs() {
    section "Other Configurations"

    # Deploy kitty config (COPY, not symlink)
    if [[ -d "$CONFIG_DIR/kitty" ]]; then
        local kitty_dest="$HOME_CONFIG/kitty"
        if [[ -e "$kitty_dest" ]]; then
            backup_config "$kitty_dest"
            rm -rf "$kitty_dest"
        fi
        run cp -r "$CONFIG_DIR/kitty" "$kitty_dest"
        ok "Kitty config copied"
    fi

    # Deploy waybar config (COPY, not symlink)
    if [[ -d "$CONFIG_DIR/waybar" ]]; then
        local waybar_dest="$HOME_CONFIG/waybar"
        if [[ -e "$waybar_dest" ]]; then
            backup_config "$waybar_dest"
            rm -rf "$waybar_dest"
        fi
        run cp -r "$CONFIG_DIR/waybar" "$waybar_dest"
        ok "Waybar config copied"
    fi

    # Deploy rofi config (COPY, not symlink)
    if [[ -d "$CONFIG_DIR/rofi" ]]; then
        local rofi_dest="$HOME_CONFIG/rofi"
        if [[ -e "$rofi_dest" ]]; then
            backup_config "$rofi_dest"
            rm -rf "$rofi_dest"
        fi
        run cp -r "$CONFIG_DIR/rofi" "$rofi_dest"
        ok "Rofi config copied"
    fi

    ok "Other configs deployed"
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    install_niri_packages
    deploy_niri_config
    deploy_other_configs
    verify_keybind_targets
    ok "Niri setup complete"
fi
