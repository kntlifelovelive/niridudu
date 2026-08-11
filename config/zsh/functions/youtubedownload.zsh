# ~/.config/zsh/functions/youtubedownload.zsh

youtubedownload() {

    command -v yt-dlp >/dev/null 2>&1 || {
        echo "Error: yt-dlp not installed"
        return 1
    }

    _parse_output() {
        [[ "$1" == "-o" && -n "$2" ]] && echo "$2" || echo "."
    }

    _show_help() {

        local GREEN="\e[1;32m"
        local BLUE="\e[1;34m"
        local YELLOW="\e[1;33m"
        local GRAY="\e[0;90m"
        local RESET="\e[0m"

        echo
        echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
        echo -e "${BLUE}              YouTube Downloader${RESET}"
        echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
        echo

        echo -e "${YELLOW}Usage${RESET}"
        echo

        echo -e "  ${GREEN}youtubedownload help${RESET}"

        echo
        echo -e "  ${GREEN}youtubedownload mp3${RESET} URL"
        echo -e "  ${GREEN}youtubedownload mp4${RESET} URL"
        echo -e "  ${GREEN}youtubedownload best${RESET} URL"

        echo
        echo -e "  ${GREEN}youtubedownload formats${RESET} URL"
        echo -e "  ${GREEN}youtubedownload info${RESET} URL"
        echo -e "  ${GREEN}youtubedownload subtitle${RESET} URL"
        echo -e "  ${GREEN}youtubedownload thumbnail${RESET} URL"

        echo
        echo -e "  ${GREEN}youtubedownload playlist${RESET} URL"
        echo -e "  ${GREEN}youtubedownload playlist-mp3${RESET} URL"

        echo
        echo -e "  ${GREEN}youtubedownload batch${RESET} urls.txt"
        echo -e "  ${GREEN}youtubedownload batch-mp3${RESET} urls.txt"
        echo -e "  ${GREEN}youtubedownload batch-playlist-mp3${RESET} urls.txt"

        echo
        echo -e "  ${GREEN}youtubedownload update${RESET}"

        echo
        echo -e "${YELLOW}Options${RESET}"
        echo
        echo "  -o DIRECTORY"

        echo
        echo -e "${YELLOW}Examples${RESET}"
        echo
        echo "  youtubedownload mp3 URL -o ~/Music"
        echo "  youtubedownload mp4 URL -o ~/Videos"
        echo "  youtubedownload playlist URL -o ~/Videos"
        echo "  youtubedownload playlist-mp3 URL -o ~/Music"
        echo "  youtubedownload batch urls.txt -o ~/Videos"
        echo "  youtubedownload batch-mp3 urls.txt -o ~/Music"
        echo "  youtubedownload batch-playlist-mp3 playlists.txt -o ~/Music"

        echo
        echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    }

    local cmd="$1"
    shift

    case "$cmd" in

        help|"")
            _show_help
            ;;

        mp3)
            local url="$1"
            shift
            local out="$(_parse_output "$@")"

            yt-dlp \
                -x \
                --audio-format mp3 \
                -o "$out/%(title)s.%(ext)s" \
                "$url"
            ;;

        mp4)
            local url="$1"
            shift
            local out="$(_parse_output "$@")"

            echo
            echo "────────────────────────────────────────"
            echo "Available Formats"
            echo "────────────────────────────────────────"
            echo

            yt-dlp -F "$url"

            echo
            read "fmt?Select format ID: "

            [[ -z "$fmt" ]] && {
                echo "Cancelled"
                return 1
            }

            yt-dlp \
                -f "${fmt}+bestaudio/best" \
                --merge-output-format mp4 \
                -o "$out/%(title)s.%(ext)s" \
                "$url"
            ;;

        best)
            local url="$1"
            shift
            local out="$(_parse_output "$@")"

            yt-dlp \
                -f "bestvideo+bestaudio/best" \
                --merge-output-format mp4 \
                -o "$out/%(title)s.%(ext)s" \
                "$url"
            ;;

        formats)
            yt-dlp -F "$1"
            ;;

        playlist)
            local url="$1"
            shift
            local out="$(_parse_output "$@")"

            yt-dlp \
                -o "$out/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" \
                "$url"
            ;;

        playlist-mp3)
            local url="$1"
            shift
            local out="$(_parse_output "$@")"

            yt-dlp \
                -x \
                --audio-format mp3 \
                -o "$out/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" \
                "$url"
            ;;

        info)
            yt-dlp \
                --print title \
                --print uploader \
                --print duration \
                "$1"
            ;;

        subtitle)
            yt-dlp \
                --write-subs \
                --write-auto-subs \
                --skip-download \
                "$1"
            ;;

        thumbnail)
            yt-dlp \
                --write-thumbnail \
                --skip-download \
                "$1"
            ;;

        batch)

            local listfile="$1"
            shift
            local out="$(_parse_output "$@")"

            [[ ! -f "$listfile" ]] && {
                echo "File not found: $listfile"
                return 1
            }

            while IFS= read -r url; do

                url=$(echo "$url" | tr -d "'\"")

                [[ -z "$url" ]] && continue
                [[ "$url" =~ ^# ]] && continue

                echo
                echo "Downloading: $url"
                echo

                yt-dlp \
                    -f "bestvideo+bestaudio/best" \
                    --merge-output-format mp4 \
                    -o "$out/%(title)s.%(ext)s" \
                    "$url"

            done < "$listfile"
            ;;

        batch-mp3)

            local listfile="$1"
            shift
            local out="$(_parse_output "$@")"

            [[ ! -f "$listfile" ]] && {
                echo "File not found: $listfile"
                return 1
            }

            while IFS= read -r url; do

                url=$(echo "$url" | tr -d "'\"")

                [[ -z "$url" ]] && continue
                [[ "$url" =~ ^# ]] && continue

                echo
                echo "Downloading MP3: $url"
                echo

                yt-dlp \
                    -x \
                    --audio-format mp3 \
                    -o "$out/%(title)s.%(ext)s" \
                    "$url"

            done < "$listfile"
            ;;

        batch-playlist-mp3)

            local listfile="$1"
            shift
            local out="$(_parse_output "$@")"

            [[ ! -f "$listfile" ]] && {
                echo "File not found: $listfile"
                return 1
            }

            while IFS= read -r url; do

                url=$(echo "$url" | tr -d "'\"")

                [[ -z "$url" ]] && continue
                [[ "$url" =~ ^# ]] && continue

                echo
                echo "Downloading Playlist MP3: $url"
                echo

                yt-dlp \
                    -x \
                    --audio-format mp3 \
                    -o "$out/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" \
                    "$url"

            done < "$listfile"
            ;;

        update)
            yt-dlp -U
            ;;

        *)
            echo "Unknown command: $cmd"
            echo "Use: youtubedownload help"
            return 1
            ;;

    esac
}
