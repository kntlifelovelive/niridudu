#!/bin/env bash

# ┌────────────────────────────────────────────┐
# │ AuthorModify : KyawNyeinThant              │
# │ Github       : kntlifelovelive             │
# │ Date         : 2026 , March, 13            │
# └────────────────────────────────────────────┘

# Niri  Used Swaylock Waybar Power Menu
# --- Configuration ---
SHUTDOWN_CMD="systemctl poweroff"
REBOOT_CMD="systemctl reboot"
LOCK_CMD="swaylock"

LOGOUT_CMD="niri msg action quit"
# LOGOUT_CMD="uwsm stop"

# --- Function to Check Dependencies ---
check_dependencies() {
  if ! command -v zenity &>/dev/null; then
    echo "Error: zenity is not installed. Please install it."
    notify-send "Error: zenity is not installed. Please install it."
    exit 1
  fi

  if ! command -v swaylock &>/dev/null; then
    echo "Warning: swaylock is not installed. Lock function will not work."
    notify-send "Warning: swaylock is not installed. Lock function will not work."
  fi
}

# Function for Lock Screen
do_lock() {
  zenity --question \
    --title="LockScreen Confirm" \
    --text="Do you want to Lock Screen Niri?" \
    --ok-label="Exit" \
    --cancel-label="Cancel"

  if [ $? -eq 0 ]; then
    echo "Exiting Niri session..."
    $LOCK_CMD
  else
    echo "Session exit cancelled."
  fi
}

# Function for Shutdown Confirmation Window
do_shutdown() {
  zenity --question \
    --title="Shutdown Confirm" \
    --text="Are you sure you want to SHUTDOWN the system?" \
    --ok-label="Shutdown" \
    --cancel-label="Cancel"

  if [ $? -eq 0 ]; then
    echo "Shutting down the system..."
    $SHUTDOWN_CMD
  else
    echo "Shutdown cancelled."
  fi
}

# Function for Reboot Confirmation Window
do_reboot() {
  zenity --question \
    --title="System Reboot" \
    --text="Are you sure you want to REBOOT the system?" \
    --ok-label="Reboot" \
    --cancel-label="Cancel"

  if [ $? -eq 0 ]; then
    echo "Rebooting the system..."
    $REBOOT_CMD
  else
    echo "Reboot cancelled."
  fi
}

# Function for exiting session (Niri)
do_logout() {
  zenity --question \
    --title="Logout Confirm" \
    --text="Do you want to exit Niri session?" \
    --ok-label="Exit" \
    --cancel-label="Cancel"

  if [ $? -eq 0 ]; then
    echo "Exiting Niri session..."
    $LOGOUT_CMD
  else
    echo "Session exit cancelled."
  fi
}

# --- Main Script Execution ---

check_dependencies

case "$1" in
--shutdown)
  do_shutdown
  ;;
--reboot)
  do_reboot
  ;;
--logout)
  do_logout
  ;;
--lock)
  do_lock
  ;;
*)
  echo "Usage: $0 {--shutdown | --reboot | --logout | --lock}"
  echo
  echo "Example: $0 --lock"
  echo "Example: $0 --shutdown"
  exit 1
  ;;
esac

exit 0
