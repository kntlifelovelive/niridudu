# ┌────────────────────────────────────────────┐
# │ AuthorModify : KyawNyeinThant,FlashAi      │
# │ Github       : kntlifelovelive             │
# │ Date         : 2026 , March, 20            │
# │ Script       : FzF Finder Search           │
# └────────────────────────────────────────────┘

# Initialize fzf for Zsh
eval "$(fzf --zsh)"

# FZF options
# export FZF_DEFAULT_OPTS="--bind 'j:down,k:up,ctrl-d:page-down,ctrl-u:page-up'"
export FZF_DEFAULT_OPTS="--bind 'j:down,k:up'"

# --- Smart File Opener with Rich Preview (Ctrl+T) ---
fzf-file-widget() {
  local preview_cmd='
    if [ -d {} ]; then
      size=$(du -sh {} | cut -f1)
      # Magenta (35) Cyan (36)
      echo -e "\e[1;35m   Folder Size:\e[0m \e[1;36m$size\e[0m"
      echo -e "\e[1;34m--------------------------------------------\e[0m"
      eza --icons=always --tree --color=always {} | head -200
    else
      case {} in
        *.png|*.jpg|*.jpeg|*.gif|*.bmp|*.webp) exiftool {} ;;
        *.mp4|*.mkv|*.avi|*.mp3|*.flac) mediainfo {} ;;
        *.pdf) exiftool {} ;;
        *) bat --color=always -n --line-range :500 {} ;;
      esac
    fi'

  local selected_path=$(fd --hidden --exclude .git | fzf \
    --layout=reverse --height=85% \
    --header="  File Search |   [Enter] Open" \
    --header-first \
    --prompt="  || Search > " \
    --preview "$preview_cmd" \
    --preview-window="right:60%:wrap:border-left")

  if [[ -n "$selected_path" ]]; then
    if [ -d "$selected_path" ]; then
      cd "$selected_path"
    elif [[ "$selected_path" =~ \.(png|jpg|jpeg|gif|mp4|mp3|mkv|pdf|docx|webp)$ ]]; then
      xdg-open "$selected_path" >/dev/null 2>&1 &
    else
      nvim "$selected_path"
    fi
  fi
  zle reset-prompt
}

# --- Folder Search (Ctrl+F)
fzf-cd-widget() {
  local dest=$(fd --type=d --hidden --exclude .git | fzf \
    --layout=reverse --height=85% \
    --header="  Folder Search |   [Enter] Change Directory" \
    --header-first \
    --prompt="    Search > " \
    --preview 'size=$(du -sh {} | cut -f1); echo -e "\e[1;35m   Folder Size:\e[0m \e[1;36m$size\e[0m"; echo -e "\e[1;34m--------------------------------------------\e[0m"; eza --icons=always --tree --color=always {} | head -200')

  [[ -n "$dest" ]] && cd "$dest"
  zle reset-prompt
}

# --- History Search (Ctrl+R) ---

fzf-history-widget() {
  local selected_history

  selected_history=$(
    fc -rl 1 |
      sed 's/^[[:space:]]*[0-9]\+[[:space:]]*//' |
      fzf \
        --layout=reverse \
        --height=85% \
        --header="  History Search |   [Enter] Insert Command" \
        --header-first \
        --prompt="    Search > " \
        --no-preview \
        --bind 'j:down,k:up,ctrl-d:page-down,ctrl-u:page-up'
  )

  if [[ -n "$selected_history" ]]; then
    LBUFFER="$selected_history"
    RBUFFER=""
  fi

  zle reset-prompt
}
