#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        05 - Zsh                            │
# │        Install zsh and setup               │
# │        NEVER modify existing zsh config    │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              Install Zsh                   │
# ═════════════════════════════════════════════┘
install_zsh() {
    section "Zsh"

    # Install zsh if not present
    if ! have zsh; then
        info "Installing zsh..."
        install_pacman "zsh"
    else
        ok "zsh already installed: $(zsh --version)"
    fi

    # Install Oh My Zsh if not present
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        info "Installing Oh My Zsh..."
        run sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        ok "Oh My Zsh installed"
    else
        ok "Oh My Zsh already installed"
    fi

    # Install plugins
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local plugins=(
        "zsh-autosuggestions|https://github.com/zsh-users/zsh-autosuggestions"
        "zsh-syntax-highlighting|https://github.com/zsh-users/zsh-syntax-highlighting"
        "zsh-completions|https://github.com/zsh-users/zsh-completions"
    )

    for plugin in "${plugins[@]}"; do
        local name="${plugin%%|*}"
        local url="${plugin#*|}"
        local dest="$zsh_custom/plugins/$name"

        if [[ ! -d "$dest" ]]; then
            info "Installing plugin: $name"
            run git clone "$url" "$dest"
            ok "Installed: $name"
        else
            ok "Plugin already installed: $name"
        fi
    done

    # Install zsh-system-clipboard (referenced in config/zsh/config/plugins.zsh)
    local clipboard_dest="${ZSH_CUSTOM:-$HOME/.zsh}/plugins/zsh-system-clipboard"
    if [[ ! -d "$clipboard_dest" ]]; then
        info "Installing plugin: zsh-system-clipboard"
        run git clone https://github.com/kutsan/zsh-system-clipboard "$clipboard_dest"
        ok "Installed: zsh-system-clipboard"
    else
        ok "Plugin already installed: zsh-system-clipboard"
    fi

    # Set default shell
    if [[ "$(basename "$SHELL")" != "zsh" ]]; then
        info "Setting default shell to zsh..."
        run chsh -s "$(command -v zsh)"
        ok "Default shell set to zsh"
    else
        ok "Default shell is already zsh"
    fi
}

# ═════════════════════════════════════════════┐
# │              Setup .zshenv                 │
# ═════════════════════════════════════════════┘
setup_zshenv() {
    section ".zshenv"

    local zshenv_src="$REPO_ROOT/zshenv/.zshenv"
    if [[ ! -f "$zshenv_src" ]]; then
        warn ".zshenv not found in repo, skipping"
        return 0
    fi

    # Backup existing .zshenv
    if [[ -f "$HOME/.zshenv" ]]; then
        backup_config "$HOME/.zshenv"
    fi

    # Copy (NOT symlink) .zshenv to home
    run cp -f "$zshenv_src" "$HOME/.zshenv"
    ok ".zshenv copied"
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    install_zsh
    setup_zshenv
    ok "Zsh setup complete"
fi
