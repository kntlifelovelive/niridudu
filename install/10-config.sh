#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        10 - Config Deployment              │
# │        Copy configs to ~/.config           │
# │        Deploy scripts to ~/.local/bin      │
# │        Deploy .zshenv to home              │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Deploy Configs                 │
# │        Copy config/* (except local)         │
# │        to ~/.config                         │
# ═════════════════════════════════════════════┘
deploy_configs() {
    section "Config Deployment"

    if [[ ! -d "$CONFIG_DIR" ]]; then
        warn "Config directory not found: $CONFIG_DIR"
        return 0
    fi

    mkdir -p "$HOME_CONFIG"

    type_text "⏳ Deploying configurations... " 0.005 "$C_CYAN"
    type_spinner "Preparing config files" 1

    # Count total items for progress bar
    local total=0
    for item in "$CONFIG_DIR"/*; do
        [[ -e "$item" ]] && ((total++))
    done

    # Iterate over each top-level item in config/
    local deployed=0
    local count=0

    for item in "$CONFIG_DIR"/*; do
        [[ -e "$item" ]] || continue
        ((count++))
        local name
        name="$(basename "$item")"

        # Skip the 'local' folder (deployed separately to ~/.local/bin)
        if [[ "$name" == "local" ]]; then
            info "Skipping $name (deployed to ~/.local/bin separately)"
            continue
        fi

        local dest="$HOME_CONFIG/$name"

        # Backup existing config
        if [[ -e "$dest" ]]; then
            backup_config "$dest"
            rm -rf "$dest"
        fi

        # Copy (NOT symlink) the config
        run cp -r "$item" "$dest"
        ((deployed++))

        show_progress "$deployed" "$total" "Configs"
        sleep 0.1
    done

    echo ""
    ok "Config deployment complete ($deployed items copied)"
}

# ═════════════════════════════════════════════┐
# │              Deploy .zshenv                 │
# │        Copy zshenv/.zshenv to ~/.zshenv     │
# ═════════════════════════════════════════════┘
deploy_zshenv() {
    section ".zshenv Deployment"

    local src="$REPO_ROOT/zshenv/.zshenv"

    if [[ ! -f "$src" ]]; then
        warn ".zshenv not found in repo: $src"
        return 0
    fi

    type_spinner "Deploying .zshenv" 1

    # Backup existing ~/.zshenv
    if [[ -f "$HOME/.zshenv" ]]; then
        backup_config "$HOME/.zshenv"
    fi

    # Copy (NOT symlink) .zshenv to home
    run cp -f "$src" "$HOME/.zshenv"
    ok ".zshenv copied to $HOME/.zshenv"
}

# ═════════════════════════════════════════════┐
# │              Deploy Local Scripts           │
# │        Copy config/local/* to ~/.local/bin  │
# ═════════════════════════════════════════════┘
deploy_local_scripts() {
    section "Local Scripts Deployment"

    local local_dir="$CONFIG_DIR/local"

    if [[ ! -d "$local_dir" ]]; then
        warn "Local scripts directory not found: $local_dir"
        return 0
    fi

    mkdir -p "$HOME_BIN"

    type_spinner "Deploying local scripts" 1

    # Count total scripts
    local total=0
    for script in "$local_dir"/*; do
        [[ -f "$script" ]] && ((total++))
    done

    local deployed=0
    for script in "$local_dir"/*; do
        [[ -f "$script" ]] || continue
        local name
        name="$(basename "$script")"

        # Copy the script to ~/.local/bin
        run cp -f "$script" "$HOME_BIN/$name"
        run chmod +x "$HOME_BIN/$name"
        ((deployed++))

        show_progress "$deployed" "$total" "Scripts"
        sleep 0.05
    done

    echo ""
    ok "Local scripts deployment complete ($deployed scripts)"
}

# ═════════════════════════════════════════════┐
# │              Ensure PATH                    │
# │        Add ~/.local/bin to PATH             │
# ═════════════════════════════════════════════┘
ensure_path() {
    section "PATH Configuration"

    mkdir -p "$HOME_CONFIG/environment.d"

    # Create PATH config if it doesn't already reference ~/.local/bin
    local path_conf="$HOME_CONFIG/environment.d/10-path.conf"
    if [[ ! -f "$path_conf" ]] || ! grep -q "$HOME_BIN" "$path_conf" 2>/dev/null; then
        cat > "$path_conf" <<EOF
PATH=$HOME_BIN:\$PATH
EOF
        ok "PATH configured for ~/.local/bin"
    else
        ok "PATH already configured"
    fi
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    deploy_configs
    deploy_zshenv
    deploy_local_scripts
    ensure_path
    ok "Config deployment complete"
fi