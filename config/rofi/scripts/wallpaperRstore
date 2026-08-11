#!/bin/env bash

# ┌────────────────────────────────────────────┐
# │ AuthorModify : KyawNyeinThant              │
# │ Github       : kntlifelovelive             │
# │ Date         : 2026 , March, 13            │
# │                                            │
# └────────────────────────────────────────────┘

STATE_FILE="$HOME/.cache/current_wallpaper"

[ ! -f "$STATE_FILE" ] && exit 0

WALL=$(cat "$STATE_FILE")

[ ! -f "$WALL" ] && exit 0

pkill swaybg 2>/dev/null
# pkill swaybg
swaybg -i "$WALL" -m fill &
