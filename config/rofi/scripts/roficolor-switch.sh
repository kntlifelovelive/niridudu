#!/bin/bash

# ┌────────────────────────────────────────────┐
# │ AuthorModify : KyawNyeinThant              │
# │ Github       : kntlifelovelive             │
# │ Date         : 2026 , March, 13            │
# │                                            │
# └────────────────────────────────────────────┘

COLOR_DIR="$HOME/.config/rofi/colors"

TARGETS=(
	"$HOME/.config/rofi/applauncher/applauncher.rasi"
	"$HOME/.config/rofi/wallpaper/wallpapers.rasi"
	"$HOME/.config/rofi/hyprlock/hyprlockWallpapers-bg.rasi"
	"$HOME/.config/rofi/hyprlock/hyprlockForeImages.rasi"
	"$HOME/.config/rofi/roficolorswitch/roficolor-switch.rasi"
	# "$HOME/.config/rofi/kitty-themes/kitty-theme-switch.rasi"
)

themes=$(basename -s .rasi -a "$COLOR_DIR"/*.rasi)

chosen=$(echo "$themes" | rofi -dmenu -i \
	-theme "$HOME/.config/rofi/roficolorswitch/roficolor-switch.rasi" \
	-p "Rofi Theme Colors = ")

[ -z "$chosen" ] && exit 0

for file in "${TARGETS[@]}"; do
	sed -i "s|@import \"colors/[^\"]*\"|@import \"colors/$chosen.rasi\"|" "$file"
done

notify-send "Rofi Color Switched" "$chosen"
