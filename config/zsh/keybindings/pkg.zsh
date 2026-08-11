# Ctrl + P → Package Finder
pkg-list-widget() {
  BUFFER='pkg list'
  zle accept-line
}

# Ctrl + Y Package install yay
pkg-install-widget() {
  BUFFER='pkg install'
  zle accept-line
}

# Ctrl + V → Package Remove Finder
pkg-remove-widget() {
  BUFFER='pkg remove'
  zle accept-line
}

pkg-search-widget() {
  BUFFER='pkg search'
  zle accept-line
}

zle -N pkg-search-widget
zle -N pkg-install-widget
zle -N pkg-list-widget
zle -N pkg-remove-widget

bindkey '^Y' pkg-install-widget
bindkey '^P' pkg-list-widget
bindkey '^V' pkg-remove-widget
bindkey '^s' pkg-search-widget
