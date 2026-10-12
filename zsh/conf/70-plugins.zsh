typeset -gA ZSH_HIGHLIGHT_STYLES

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5f6b75'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)
ZSH_HIGHLIGHT_STYLES[alias]='fg=#c4b5fd'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#73c991'
ZSH_HIGHLIGHT_STYLES[command]='fg=#73c991'
ZSH_HIGHLIGHT_STYLES[function]='fg=#73c991'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#f6c177'
ZSH_HIGHLIGHT_STYLES[path]='fg=#e6e4e1'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#8a9aa5'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#c4b5fd'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#f6c177'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#f6c177'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff7b72'
ZSH_HIGHLIGHT_STYLES[cursor]='bg=#1e1e1e'

for _f in /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-autosuggestions/zsh-autosuggestions.zsh; do
  [[ -r $_f ]] && { source $_f; break; }
done

for _f in /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
  [[ -r $_f ]] && { source $_f; break; }
done
