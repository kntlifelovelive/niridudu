# ====== Ctrl+F Folder Search Key Map
bindkey '^t' fzf-file-widget
bindkey -M viins '^t' fzf-file-widget
bindkey -M vicmd '^t' fzf-file-widget

# ==== File Search Key Map
zle -N fzf-cd-widget
bindkey '^f' fzf-cd-widget
bindkey -M viins '^f' fzf-cd-widget
bindkey -M vicmd '^f' fzf-cd-widget

# History
zle -N fzf-history-widget
bindkey '^r' fzf-history-widget
bindkey -M viins '^r' fzf-history-widget
bindkey -M vicmd '^r' fzf-history-widget
