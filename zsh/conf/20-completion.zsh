zmodload zsh/complist
autoload -Uz compinit

_zcompdump="${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"
compinit -d "$_zcompdump"

zstyle ':completion:*' accept-exact-dirs true
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' file-sort name
zstyle ':completion:*' format $'%F{8}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%S%M matches%s'
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt '%Sscrolling: %p%s'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' verbose yes
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:descriptions' format $'%F{8}%d%f'

if [[ -o interactive ]] && [[ -t 0 ]] && [[ -t 1 ]] && [[ -z ${ZSH_EXECUTION_STRING:-} ]] && (( ${+commands[fzf]} )); then
  if [[ -r /usr/share/doc/fzf/examples/completion.zsh ]]; then
    source /usr/share/doc/fzf/examples/completion.zsh
  elif [[ -n ${HOMEBREW_PREFIX:-} && -r $HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh ]]; then
    source $HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh
  fi
fi
