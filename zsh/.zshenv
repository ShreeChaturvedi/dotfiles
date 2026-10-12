export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"
export HISTFILE="${HISTFILE:-$XDG_STATE_HOME/zsh/history}"

for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [[ -x $_brew ]] && { eval "$($_brew shellenv)"; break; }
done
unset _brew

for _d in "$HOME/.bun/bin" "$HOME/bin" "$HOME/.local/bin"; do
  [[ -d $_d ]] && export PATH="$_d:$PATH"
done
unset _d
