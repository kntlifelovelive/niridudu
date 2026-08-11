# fastdownload.zsh - V3 starter edition
# Source from ~/.zshrc:
# source ~/.config/zsh/functions/fastdownload.zsh

fastdownload() {
    local CFG_DIR="$HOME/.config/fastdownload"
    local HISTORY_FILE="$CFG_DIR/history.log"
    local STATS_FILE="$CFG_DIR/stats.db"
    local CONFIG_FILE="$CFG_DIR/config"

    mkdir -p "$CFG_DIR"

    [[ ! -f "$CONFIG_FILE" ]] && cat > "$CONFIG_FILE" <<EOF
DOWNLOAD_DIR=$HOME/Downloads
CONNECTIONS=16
SPLIT=16
RETRY=10
EOF

    source "$CONFIG_FILE" 2>/dev/null

    _log_history() {
        echo "$(date '+%F %T')|$1|$2" >> "$HISTORY_FILE"
    }

    _inc_stat() {
        local key="$1"
        local value="$2"
        touch "$STATS_FILE"
        local current=$(grep "^${key}=" "$STATS_FILE" 2>/dev/null | cut -d= -f2)
        current=${current:-0}
        current=$((current + value))
        grep -v "^${key}=" "$STATS_FILE" 2>/dev/null > "$STATS_FILE.tmp"
        echo "${key}=${current}" >> "$STATS_FILE.tmp"
        mv "$STATS_FILE.tmp" "$STATS_FILE"
    }

    _download() {
        local url="$1"
        aria2c \
          --continue=true \
          --max-connection-per-server="${CONNECTIONS:-16}" \
          --split="${SPLIT:-16}" \
          --max-tries="${RETRY:-10}" \
          -d "${DOWNLOAD_DIR:-$HOME/Downloads}" \
          "$url"

        if [[ $? -eq 0 ]]; then
            _log_history SUCCESS "$url"
            _inc_stat downloads 1
        else
            _log_history FAILED "$url"
        fi
    }

    case "$1" in
        history)
            [[ -f "$HISTORY_FILE" ]] && cat "$HISTORY_FILE" || echo "No history"
            ;;
        stats)
            [[ -f "$STATS_FILE" ]] && cat "$STATS_FILE" || echo "No stats"
            ;;
        config)
            cat "$CONFIG_FILE"
            ;;
        doctor)
            for cmd in aria2c curl; do
                command -v "$cmd" >/dev/null && echo "[OK] $cmd" || echo "[FAIL] $cmd"
            done
            command -v gdown >/dev/null && echo "[OK] gdown" || echo "[WARN] gdown optional"
            ;;
        --info)
            curl -sIL "$2" | grep -Ei 'content-length|content-type|content-disposition'
            ;;
        --gdrive)
            gdown "$2"
            ;;
        --batch)
            while IFS= read -r url; do
                [[ -z "$url" || "$url" =~ ^# ]] && continue
                _download "$url"
            done < "$2"
            ;;
        ""|-h|--help)
            cat <<EOF
fastdownload URL
fastdownload --batch urls.txt
fastdownload --gdrive URL
fastdownload --info URL
fastdownload history
fastdownload stats
fastdownload config
fastdownload doctor
EOF
            ;;
        *)
            _download "$1"
            ;;
    esac
}
