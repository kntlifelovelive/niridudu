#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │        Niri Dotfiles Installer             │
# │        Author: NiriBuBu                    │
# │        Date: 2026                          │
# │        Run: ./install.sh                   │
# │        User-level by default                │
# └────────────────────────────────────────────┘

set -euo pipefail

# ═════════════════════════════════════════════
# Configuration
# ═════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$SCRIPT_DIR/install"

# One backup directory for the whole installation run.
export NIRI_INSTALL_BACKUP_DIR="$HOME/.niri-backup-$(date +%Y%m%d-%H%M%S)"

# ═════════════════════════════════════════════
# Colors
# ═════════════════════════════════════════════

C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[1;33m'
C_BLUE='\033[0;34m'
C_CYAN='\033[1;36m'
C_RESET='\033[0m'

# ═════════════════════════════════════════════
# Helper Functions
# ═════════════════════════════════════════════

info() { echo -e "${C_CYAN}[INFO]${C_RESET} $1"; }
ok() { echo -e "${C_GREEN}[OK]${C_RESET} $1"; }
warn() { echo -e "${C_YELLOW}[WARN]${C_RESET} $1"; }
error() {
  echo -e "${C_RED}[ERROR]${C_RESET} $1"
  exit 1
}

# ═════════════════════════════════════════════
# Run Module
# ═════════════════════════════════════════════

run_module() {
  local module="$1"
  local module_path="$INSTALL_DIR/$module"

  if [[ ! -f "$module_path" ]]; then
    error "Module not found: $module"
  fi

  info "Running module: $module"

  if ! bash "$module_path"; then
    error "Module failed: $module"
  fi

  ok "Module complete: $module"
}

# ═════════════════════════════════════════════
# Main Orchestrator
# ═════════════════════════════════════════════

main() {
  # Shared installer library
  # shellcheck source=install/lib.sh
  source "$INSTALL_DIR/lib.sh"

  show_banner

  echo -e "${C_CYAN}Backup directory:${C_RESET}"
  echo "  $BACKUP_DIR"
  echo ""

  # ── Confirmation ──────────────────────────
  read -rp "Do you want to start the installation? (y/n): " confirm

  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Installation canceled."
    exit 0
  fi

  echo ""

  # ══════════════════════════════════════════
  # Installation Order
  # ══════════════════════════════════════════
  #
  # 00-check
  #      ↓
  # 01-yay
  #      ↓
  # 12-packages
  #      ↓
  # setup modules
  #      ↓
  # 10-config (FINAL CONFIG DEPLOYMENT)
  #      ↓
  # 99-finish
  #
  # Packages are installed before all setup modules.
  # Config deployment remains the final deployment step.

  local modules=(
    "00-check.sh"
    "01-yay.sh"
    "installpackages.sh"
    "03-fonts.sh"
    "04-themes.sh"
    "05-zsh.sh"
    "06-network.sh"
    "07-bluetooth.sh"
    "08-niri.sh"
    "09-wallpaper.sh"
    "11-audio.sh"
    "10-config.sh"
  )

  # ══════════════════════════════════════════
  # Run Modules
  # ══════════════════════════════════════════

  for module in "${modules[@]}"; do
    run_module "$module"
  done

  # ══════════════════════════════════════════
  # Final Summary
  # ══════════════════════════════════════════

  run_module "99-finish.sh"

  ok "Installation complete!"
}

main "$@"
