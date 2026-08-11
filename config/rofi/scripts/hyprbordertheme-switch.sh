#!/bin/bash

# ┌────────────────────────────────────────────┐
# │ AuthorModify : KyawNyeinThant              │
# │ Github       : kntlifelovelive             │
# │ Date         : 2026 , March, 13            │
# │                                            │
# └────────────────────────────────────────────┘

THEME_DIR="$HOME/.config/rofi/hyprbordercolortheme/"
TARGET="$HOME/.config/rofi/colors/colors.conf"

# themes=$(find "$THEME_DIR" -maxdepth 1 -type f -iname "*.conf" -printf "%f\n" | sort)
themes=$(basename -s .conf -a "$THEME_DIR"/*.conf | sort)

chosen=$(echo "$themes" | rofi -dmenu -i \
  -theme "$HOME/.config/rofi/hyprbordertheme/hyprbordertheme-switch.rasi" \
  -p "HyprBorder-Theme = ")

[ -z "$chosen" ] && exit 0

cp "$THEME_DIR/$chosen" "$TARGET"

hyprctl reload

notify-send "Hyprland Theme Switched" "$chosen"
