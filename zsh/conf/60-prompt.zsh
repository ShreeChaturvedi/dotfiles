if (( ${+commands[starship]} )); then
  export STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship.toml"
  eval "$(starship init zsh)"

  autoload -Uz add-zsh-hook add-zle-hook-widget

  typeset -g STARSHIP_FULL_PROMPT="$PROMPT"
  typeset -g STARSHIP_FULL_RPROMPT="$RPROMPT"
  typeset -g STARSHIP_TRANSIENT_PROMPT='$ '
  typeset -g STARSHIP_TRANSIENT_RPROMPT=''

  starship_transient_prompt_restore() {
    PROMPT="$STARSHIP_FULL_PROMPT"
    RPROMPT="$STARSHIP_FULL_RPROMPT"
  }

  starship_transient_prompt_minimize() {
    PROMPT="$STARSHIP_TRANSIENT_PROMPT"
    RPROMPT="$STARSHIP_TRANSIENT_RPROMPT"
    zle reset-prompt
  }

  add-zsh-hook -d precmd starship_transient_prompt_restore 2>/dev/null || true
  add-zle-hook-widget -d line-finish starship_transient_prompt_minimize 2>/dev/null || true
  add-zsh-hook precmd starship_transient_prompt_restore
  add-zle-hook-widget line-finish starship_transient_prompt_minimize
fi
