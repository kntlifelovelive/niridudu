#!/usr/bin/env bash

# ┌────────────────────────────────────────────┐
# │ AuthorModify : KyawNyeinThant              │
# │ Github       : kntlifelovelive             │
# │ Date         : 2026 , March, 13            │
# │                                            │
# └────────────────────────────────────────────┘

THEME_DIR="$HOME/.config/kitty/themes"
CURRENT="$HOME/.config/kitty/current-theme.conf"

themes=$(basename -s .conf "$THEME_DIR"/*.conf | sort)

chosen=$(printf "%s\n" $themes | rofi -dmenu -i \
  -p "Kitty Theme = " \
  -theme-str '
window {
    width: 350px;
    padding: 18px;
    border-radius: 0px;
    border: 1px;
    border-color: #7aa2f7;
    background-color: rgba(26,27,38,0.95);
}

listview {
    lines: 20;
    fixed-height: true;
    scrollbar: false;
    spacing: 1px;
    background-color: rgba(26,27,38,0.95);
}

element {
    padding: 1px;
    border-radius: 0px;
    background-color: rgba(26,27,38,0.95);
    text-color: #cdd6f4;
}

element selected {
    background-color: rgba(122,162,247,0.25);
    text-color: #cdd6f4;
}

prompt {
    text-color: #7dcfff;
    font: "JetBrainsMono Bold 15";
}

entry {
    text-color: #cdd6f4;
    background-color: rgba(26,27,38,0.95);
    placeholder-color: #6c7086;
    font: "JetBrainsMono Bold 13";
}
')

[ -z "$chosen" ] && exit 0

# create symlink
ln -sf "$THEME_DIR/$chosen.conf" "$CURRENT"

# reload kitty instantly
kitty @ load-config 2>/dev/null

notify-send "Kitty Theme" "Switched to $chosen"
