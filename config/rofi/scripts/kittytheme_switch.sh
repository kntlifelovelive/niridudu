#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │ AuthorModify : KyawNyeinThant              │
# │ Github       : kntlifelovelive             │
# │ Date         : 2026 , March, 13            │
# │                                            │
# └────────────────────────────────────────────┘

THEME_DIR="$HOME/.config/kitty/themes"
CURRENT="$HOME/.config/kitty/current-theme.conf"
ROFI_THEME="$HOME/.config/rofi/kitty-themes/kitty-theme-switch.rasi"

themes=$(basename -s .conf "$THEME_DIR"/*.conf | sort)

chosen=$(printf "%s\n" $themes | rofi -dmenu -i \
  -theme "$ROFI_THEME" \
  -p "Kitty Theme = ")

[ -z "$chosen" ] && exit 0

# create symlink
ln -sf "$THEME_DIR/$chosen.conf" "$CURRENT"

# reload kitty instantly
kitty @ load-config 2>/dev/null

notify-send "Kitty Theme" "Switched to $chosen"
