#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        Shared Library for Installer        │
# │        Author: NiriBuBu                   │
# │        Date: 2026                          │
# │        With beautiful visual effects       │
# └────────────────────────────────────────────┘

# ═════════════════════════════════════════════┐
# │              Configuration                 │
# ═════════════════════════════════════════════┘
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
INSTALL_DIR="$REPO_ROOT/install"
CONFIG_DIR="$REPO_ROOT/config"
PACKAGES_FILE="$REPO_ROOT/packages/packages.txt"
SYSTEMD_DIR="$REPO_ROOT/config/systemd/user"
THEMES_DIR="$REPO_ROOT/config/themes"

HOME_CONFIG="$HOME/.config"
HOME_BIN="$HOME/.local/bin"
HOME_SHARE="$HOME/.local/share"
HOME_STATE="$HOME/.local/state"
BACKUP_DIR="$HOME/.niri-backup-$(date +%Y%m%d-%H%M%S)"

# Local bin is where config/local scripts are deployed
SCRIPTS_DIR="$HOME_BIN"

# ═════════════════════════════════════════════┐
# │              Colors                        │
# ═════════════════════════════════════════════┘
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[1;33m'
C_BLUE='\033[0;34m'
C_CYAN='\033[1;36m'
C_MAGENTA='\033[0;35m'
C_WHITE='\033[1;37m'
C_BOLD='\033[1m'
C_DIM='\033[2m'
C_RESET='\033[0m'

# ═════════════════════════════════════════════┐
# │              Helper Functions              │
# ═════════════════════════════════════════════┘
info()  { echo -e "${C_CYAN}[INFO]${C_RESET} $1"; }
ok()    { echo -e "${C_GREEN}[✓]${C_RESET} $1"; }
warn()  { echo -e "${C_YELLOW}[⚠]${C_RESET} $1"; }
error() { echo -e "${C_RED}[✗]${C_RESET} $1"; exit 1; }

# Beautiful section header with box drawing
section() {
    local title="$1"
    local width=60
    local title_len=${#title}
    local pad=$(( (width - title_len - 2) / 2 ))
    local left_pad=""
    local right_pad=""

    for ((i=0; i<pad; i++)); do left_pad+="─"; done
    for ((i=0; i<width - title_len - 2 - pad; i++)); do right_pad+="─"; done

    echo ""
    echo -e "${C_MAGENTA}┌${left_pad} ${C_BOLD}${C_WHITE}${title}${C_RESET} ${C_MAGENTA}${right_pad}┐${C_RESET}"
    echo -e "${C_MAGENTA}└${C_RESET}${C_DIM}──────────────────────────────────────────────────────────${C_RESET}${C_MAGENTA}┘${C_RESET}"
    echo ""
}

# ═════════════════════════════════════════════┐
# │              Typing Animation              │
# │        "Neo typing" effect                 │
# ═════════════════════════════════════════════┘
# Type text character by character
type_text() {
    local text="$1"
    local delay="${2:-0.01}"
    local color="${3:-$C_CYAN}"

    echo -ne "${color}"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo -e "${C_RESET}"
}

# Type a message with a spinner
type_spinner() {
    local text="$1"
    local duration="${2:-2}"
    local spinner=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local end=$((SECONDS + duration))

    echo -ne "${C_CYAN}${text}${C_RESET} "
    local i=0
    while [[ $SECONDS -lt $end ]]; do
        echo -ne "\r${C_MAGENTA}${spinner[$((i % ${#spinner[@]}))]}${C_RESET} ${C_CYAN}${text}${C_RESET} "
        i=$((i + 1))
        sleep 0.1
    done
    echo -e "\r${C_GREEN}✓${C_RESET} ${C_CYAN}${text}${C_RESET} "
}

# ═════════════════════════════════════════════┐
# │              Progress Bar                  │
# ═════════════════════════════════════════════┘
show_progress() {
    local current="$1"
    local total="$2"
    local label="${3:-Progress}"
    local width=40
    local pct=$((current * 100 / total))
    local fill=$((pct * width / 100))
    local empty=$((width - fill))
    local bar=""

    for ((i=0; i<fill; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done

    printf "\r${C_CYAN}${label}:${C_RESET} ${C_GREEN}[${bar}]${C_RESET} ${C_WHITE}%3d%%${C_RESET}" "$pct"
}

# ═════════════════════════════════════════════┐
# │              ASCII Art Banner              │
# ═════════════════════════════════════════════┘
show_banner() {
    echo ""
    echo -e "${C_MAGENTA}    ███╗   ██╗██╗██████╗ ██╗    ██████╗ ██╗   ██╗██████╗ ██╗   ██╗${C_RESET}"
    echo -e "${C_MAGENTA}    ████╗  ██║██║██╔══██╗██║    ██╔══██╗██║   ██║██╔══██╗██║   ██║${C_RESET}"
    echo -e "${C_MAGENTA}    ██╔██╗ ██║██║██████╔╝██║    ██████╔╝██║   ██║██████╔╝██║   ██║${C_RESET}"
    echo -e "${C_MAGENTA}    ██║╚██╗██║██║██╔══██╗██║    ██╔══██╗██║   ██║██╔══██╗██║   ██║${C_RESET}"
    echo -e "${C_MAGENTA}    ██║ ╚████║██║██║  ██║██║    ██████╔╝╚██████╔╝██████╔╝╚██████╔╝${C_RESET}"
    echo -e "${C_MAGENTA}    ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝╚═╝    ╚═════╝  ╚═════╝ ╚═════╝  ╚═════╝ ${C_RESET}"
    echo ""
    echo -e "${C_CYAN}    ═══════════════════════════════════════════════════════════${C_RESET}"
    echo -e "${C_WHITE}    ${C_BOLD}Niri Dotfiles Installer${C_RESET} ${C_DIM}by ArchiBuBu${C_RESET}"
    echo -e "${C_CYAN}    ═══════════════════════════════════════════════════════════${C_RESET}"
    echo ""
}

# ═════════════════════════════════════════════┐
# │              Dry-run Support               │
# ═════════════════════════════════════════════┘
DRY_RUN="${DRY_RUN:-0}"
CHECK_MODE="${CHECK_MODE:-0}"

# Command wrapper that respects dry-run and check modes
run() {
    if [[ "$DRY_RUN" == "1" ]]; then
        echo -e "${C_YELLOW}[DRY-RUN]${C_RESET} $*"
        return 0
    fi
    "$@"
}

# Check if a command exists
have() {
    command -v "$1" >/dev/null 2>&1
}

# Check if a package is installed
pkg_installed() {
    pacman -Q "$1" >/dev/null 2>&1
}

# Backup a config directory if it exists
backup_config() {
    local src="$1"
    local name
    name="$(basename "$src")"

    if [[ -e "$src" ]]; then
        mkdir -p "$BACKUP_DIR"
        info "Backing up $src → $BACKUP_DIR/"
        cp -r "$src" "$BACKUP_DIR/"
    fi
}

# Ensure we're running as normal user
check_not_root() {
    if [[ $EUID -eq 0 ]]; then
        error "This installer should NOT be run as root. Run as a normal user."
    fi
}

# Detect Arch Linux
check_arch() {
    if [[ ! -f /etc/os-release ]]; then
        error "Cannot detect OS. /etc/os-release not found."
    fi

    local distro
    distro="$(grep -E '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')"

    if [[ "$distro" != "arch" ]]; then
        error "This installer is for Arch Linux only. Detected: $distro"
    fi
}

# Check internet connectivity
check_internet() {
    if ! ping -c 1 -W 2 archlinux.org &>/dev/null; then
        error "No internet connection detected."
    fi
}

# Install package via pacman if not already installed
install_pacman() {
    local pkg="$1"
    if pkg_installed "$pkg"; then
        ok "Already installed: $pkg"
        return 0
    fi
    info "Installing (pacman): $pkg"
    run sudo pacman -S --needed --noconfirm "$pkg"
}

# Install package via yay (AUR)
install_aur() {
    local pkg="$1"
    if pkg_installed "$pkg"; then
        ok "Already installed: $pkg"
        return 0
    fi
    info "Installing (AUR): $pkg"
    run yay -S --needed --noconfirm "$pkg"
}

# Install a list of packages, auto-detecting pacman vs AUR
install_packages() {
    local pkg
    for pkg in "$@"; do
        if pkg_installed "$pkg"; then
            ok "Already installed: $pkg"
            continue
        fi
        if pacman -Si "$pkg" &>/dev/null; then
            install_pacman "$pkg"
        else
            install_aur "$pkg"
        fi
    done
}