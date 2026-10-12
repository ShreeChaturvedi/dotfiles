bindkey -v

bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins 'jk' vi-cmd-mode

if [[ -o interactive ]] && [[ -t 0 ]] && [[ -t 1 ]] && [[ -z ${ZSH_EXECUTION_STRING:-} ]] && (( ${+commands[fzf]} )); then
  if [[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
  elif [[ -n ${HOMEBREW_PREFIX:-} && -r $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh ]]; then
    source $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh
  fi
fi
