#!/usr/bin/env bash
# Symlink these configs into place. Existing files are moved to *.pre-dotfiles.
set -euo pipefail
DOT="$(cd "$(dirname "$0")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"

if [[ "$(uname)" == Darwin ]] && command -v brew >/dev/null && [[ "${1:-}" != --no-brew ]]; then
  brew bundle --file="$DOT/Brewfile" || echo "brew bundle had failures, continuing"
fi

link() {
  local src="$DOT/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then mv "$dst" "$dst.pre-dotfiles"; fi
  ln -sfn "$src" "$dst"
  echo "linked $dst"
}

link kitty "$CFG/kitty"
link nvim "$CFG/nvim"
link starship/starship.toml "$CFG/starship.toml"
link tmux/tmux.conf "$HOME/.tmux.conf"
link vim/vimrc "$HOME/.vimrc"
link zsh/.zshrc "$CFG/zsh/.zshrc"
link zsh/conf "$CFG/zsh/conf"
link zsh/.zshenv "$HOME/.zshenv"
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh" "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

if [[ ! -d "$DATA/zsh/plugins/fzf-tab" ]]; then
  git clone --depth 1 https://github.com/Aloxaf/fzf-tab "$DATA/zsh/plugins/fzf-tab"
fi
echo "done. open a new terminal."
