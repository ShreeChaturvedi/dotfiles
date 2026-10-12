if (( ${+commands[zoxide]} )); then
  eval "$(zoxide init zsh)"
fi

if (( ${+commands[direnv]} )); then
  eval "$(direnv hook zsh)"
fi

if (( ${+commands[atuin]} )); then
  eval "$(atuin init zsh --disable-up-arrow)"
fi
