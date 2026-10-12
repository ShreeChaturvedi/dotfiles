if [[ -d "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions" ]]; then
  fpath=("${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions" $fpath)
fi
