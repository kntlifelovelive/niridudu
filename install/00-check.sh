#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        00 - System Check                   │
# │        Verify system prerequisites         │
# └────────────────────────────────────────────┘

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib.sh
source "$SCRIPT_DIR/lib.sh"

# ═════════════════════════════════════════════┐
# │              System Checks                 │
# ═════════════════════════════════════════════┘
check_system() {
    section "System Check"

    # 1. Check Arch Linux
    info "Checking OS..."
    check_arch
    ok "Arch Linux confirmed"

    # 2. Check user is not root
    info "Checking user..."
    check_not_root
    ok "Running as: $USER"

    # 3. Check internet connectivity
    info "Checking internet connectivity..."
    check_internet
    ok "Internet connection available"

    # 4. Check required commands
    info "Checking required commands..."
    local required=(
        "pacman"
        "sudo"
        "git"
        "curl"
        "wget"
    )

    local missing=()
    for cmd in "${required[@]}"; do
        if have "$cmd"; then
            ok "Found: $cmd"
        else
            missing+=("$cmd")
        fi
    done

    if ((${#missing[@]} > 0)); then
        error "Missing required commands: ${missing[*]}"
    fi

    # 5. Check package.json exists
    if [[ ! -f "$PACKAGES_FILE" ]]; then
        error "Packages file not found: $PACKAGES_FILE"
    fi
    ok "Packages file found"

    # 6. Display summary
    echo ""
    echo -e "${C_CYAN}System Summary:${C_RESET}"
    echo "  OS:          $(grep -E '^PRETTY_NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '"')"
    echo "  Kernel:      $(uname -r)"
    echo "  User:        $USER"
    echo "  Shell:       $SHELL"
    echo "  CPU:         $(uname -m)"
    echo "  Backup dir:  $BACKUP_DIR"
    echo ""
}

# Run only if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    check_system
    ok "System check complete"
fi