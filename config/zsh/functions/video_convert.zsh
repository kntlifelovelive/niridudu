# ~/.config/zsh/functions/videoconvertmp3.zsh

videoconvertmp3() {

    command -v ffmpeg >/dev/null 2>&1 || {
        echo "[FAIL] ffmpeg not installed"
        return 1
    }

    command -v ffprobe >/dev/null 2>&1 || {
        echo "[FAIL] ffprobe not installed"
        return 1
    }

    local GREEN="\e[1;32m"
    local BLUE="\e[1;34m"
    local RED="\e[1;31m"
    local RESET="\e[0m"

    [[ "$1" == "-v" || "$1" == "--verbose" ]] && {
        local verbose=1
        shift
    }

    [[ $# -eq 0 ]] && {
        echo "Usage: videoconvertmp3 file|dir"
        return 0
    }

    get_duration() {
        ffprobe -v error -show_entries format=duration \
        -of default=noprint_wrappers=1:nokey=1 "$1"
    }

    human_size() {
        local bytes=$1
        awk -v b="$bytes" 'BEGIN {
            split("B KB MB GB TB", u, " ");
            i=1;
            while (b >= 1024 && i < 5) { b /= 1024; i++ }
            printf "%.2f %s", b, u[i]
        }'
    }

    draw_bar() {
        local percent=$1
        local speed=$2
        local size=$3

        local width=30
        local fill=$((percent * width / 100))
        local empty=$((width - fill))

        printf "\r\033[K${GREEN}["
        for ((i=0;i<fill;i++)); do printf "█"; done
        for ((i=0;i<empty;i++)); do printf "░"; done
        printf "] %3d%%  speed:%sx  size:%s${RESET}" \
            "$percent" "$speed" "$size"
    }

    convert_file() {

        local file="$1"
        local output="${file%.*}.mp3"

        echo
        echo "${BLUE}[INFO]${RESET} $(basename "$file")"

        local duration
        duration=$(get_duration "$file")
        [[ -z "$duration" ]] && duration=1

        local last_size="0 B"
        local speed="0"

        ffmpeg -y -nostdin -hide_banner -loglevel error \
            -i "$file" -vn -c:a libmp3lame -q:a 4 \
            -progress pipe:1 "$output" 2>/dev/null |
        while IFS= read -r line; do

            case "$line" in

                out_time_ms=*)
                    t=${line#*=}
                    t=$((t / 1000000))

                    percent=$(( t * 100 / duration ))
                    ((percent>100)) && percent=100

                    draw_bar "$percent" "$speed" "$last_size"
                    ;;

                speed=*)
                    speed="${line#*=}"
                    ;;

                total_size=*)
                    last_size=$(human_size "${line#*=}")
                    ;;

            esac

        done

        printf "\n"

        if [[ ${PIPESTATUS[0]} -eq 0 ]]; then
            echo "${GREEN}[ OK ]${RESET} $(basename "$output")"
        else
            echo "${RED}[FAIL]${RESET} $(basename "$output")"
        fi
    }

    for item in "$@"; do

        if [[ -d "$item" ]]; then
            find "$item" -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.avi" -o -iname "*.mov" \) |
            while read -r file; do
                convert_file "$file"
            done

        elif [[ -f "$item" ]]; then
            convert_file "$item"
        fi

    done
}
