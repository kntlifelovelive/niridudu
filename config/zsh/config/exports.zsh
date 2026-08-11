# ~/.config/zsh/config/exports.zsh
# PATH and environment variables

# ============================================
# PATH additions
# ============================================
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

# ============================================
# Virtualization
# ============================================
export LIBVIRT_DEFAULT_URI="qemu:///system"

# ============================================
# Editor
# ============================================
export EDITOR=nvim
export VISUAL=nvim

# ============================================
# Terminal
# ============================================

[[ "$TERM" == "kitty" ]] && export TERM=xterm-256color

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORMTHEME=qt6ct
