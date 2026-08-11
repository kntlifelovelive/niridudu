#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        Niri Dotfiles Installer             │
# │        Author: NiriBuBu                    │
# │        Date: 2026                          │
# │        User-level by default               │
# │        Package install optional (--full)   │
# └────────────────────────────────────────────┘

set -euo pipefail

# ┌────────────────────────────────────────────┐
# │              Configuration                 │
# └────────────────────────────────────────────┘
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$SCRIPT_DIR/install"

# ┌────────────────────────────────────────────┐
# │              Colors                        │
# └────────────────────────────────────────────┘
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[1;33m'
C_BLUE='\033[0;34m'
C_CYAN='\033[1;36m'
C_RESET='\033[0m'

# ┌────────────────────────────────────────────┐
# │              Helper Functions              │
# └────────────────────────────────────────────┘
info()  { echo -e "${C_CYAN}[INFO]${C_RESET} $1"; }
ok()    { echo -e "${C_GREEN}[OK]${C_RESET} $1"; }
warn()  { echo -e "${C_YELLOW}[WARN]${C_RESET} $1"; }
error() { echo -e "${C_RED}[ERROR]${C_RESET} $1"; exit 1; }

# ┌────────────────────────────────────────────┐
# │              Usage                         │
# └────────────────────────────────────────────┘
usage() {
    cat <<EOF
Usage: install.sh [OPTIONS]

Default: User-level config deployment (no sudo required)

Options:
  --full          Full installation (packages + configs, requires sudo)
  --dry-run       Show what would be done without executing
  --check         Check system readiness without installing
  --module NAME   Run a specific module (e.g. 10-config)
  --list          List available modules
  --help          Show this help

Examples:
  ./install.sh                    # User-level config deployment
  ./install.sh --full             # Full install (packages + configs)
  ./install.sh --dry-run          # Preview installation
  ./install.sh --module 10-config # Run only config deployment
EOF
}

# ┌────────────────────────────────────────────┐
# │              List Modules                  │
# └────────────────────────────────────────────┘
list_modules() {
    echo "Available modules:"
    echo "  (user-level, no sudo)"
    for module in "$INSTALL_DIR"/[0-9]*.sh; do
        [[ -f "$module" ]] || continue
        local name
        name="$(basename "$module")"
        echo "  $name"
    done
    echo ""
    echo "Usage: ./install.sh --module <name>"
}

# ┌────────────────────────────────────────────┐
# │              Run Module                    │
# └────────────────────────────────────────────┘
run_module() {
    local module="$1"
    local module_path="$INSTALL_DIR/$module"

    if [[ ! -f "$module_path" ]]; then
        error "Module not found: $module"
    fi

    info "Running module: $module"
    bash "$module_path"
    ok "Module complete: $module"
}

# ┌────────────────────────────────────────────┐
# │              Main Orchestrator             │
# └────────────────────────────────────────────┘
main() {
    # Parse arguments
    local full_install=0
    local dry_run=0
    local check_mode=0
    local specific_module=""

    local args=("$@")
    local i=0
    while [[ $i -lt ${#args[@]} ]]; do
        local arg="${args[$i]}"
        case "$arg" in
            --full)
                full_install=1
                ;;
            --dry-run)
                dry_run=1
                ;;
            --check)
                check_mode=1
                ;;
            --module)
                if [[ $((i + 1)) -lt ${#args[@]} ]]; then
                    specific_module="${args[$((i + 1))]}"
                    i=$((i + 1))
                else
                    error "--module requires a module name"
                fi
                ;;
            --list)
                list_modules
                exit 0
                ;;
            --help|-h)
                usage
                exit 0
                ;;
            *)
                if [[ "$arg" =~ ^[0-9]{2}-.*\.sh$ ]]; then
                    specific_module="$arg"
                fi
                ;;
        esac
        i=$((i + 1))
    done

    # Export modes for modules
    export DRY_RUN="$dry_run"
    export CHECK_MODE="$check_mode"

    # Banner (beautiful ASCII art)
    source "$INSTALL_DIR/lib.sh"
    show_banner

    if [[ "$dry_run" == "1" ]]; then
        warn "DRY-RUN MODE - No changes will be made"
        echo ""
    fi

    if [[ "$check_mode" == "1" ]]; then
        info "CHECK MODE - Only checking system readiness"
        echo ""
    fi

    # Run specific module if requested
    if [[ -n "$specific_module" ]]; then
        run_module "$specific_module"
        exit 0
    fi

    # Mode selection banner
    if [[ "$full_install" == "1" ]]; then
        info "FULL INSTALL MODE - packages + configs (requires sudo)"
        echo ""
    else
        info "USER-LEVEL MODE - config deployment only (no sudo)"
        echo ""
    fi

    # Ask for confirmation
    read -rp "Do you want to start the installation? (y/n): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Installation canceled."
        exit 0
    fi

    # User-level modules (default - always run)
    local user_modules=(
        "10-config.sh"
        "99-finish.sh"
    )

    # Full install modules (optional - requires sudo)
    local full_modules=(
        "00-check.sh"
        "01-yay.sh"
        "02-packages.sh"
        "03-fonts.sh"
        "04-themes.sh"
        "05-zsh.sh"
        "06-network.sh"
        "07-bluetooth.sh"
        "08-niri.sh"
        "09-wallpaper.sh"
    )

    # Run user-level modules first
    for module in "${user_modules[@]}"; do
        if [[ "$check_mode" == "1" ]]; then
            continue
        fi
        run_module "$module"
    done

    # Run full install modules only if --full is requested
    if [[ "$full_install" == "1" ]]; then
        for module in "${full_modules[@]}"; do
            if [[ "$check_mode" == "1" ]]; then
                continue
            fi
            run_module "$module"
        done
    else
        warn "Skipping package modules (run with --full to install packages)"
        echo ""
        info "To install packages too: ./install.sh --full"
        echo ""
    fi

    ok "Installation complete!"
}

main "$@"