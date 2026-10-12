HISTSIZE=100000
SAVEHIST=100000
KEYTIMEOUT=1
WORDCHARS=''

setopt auto_cd
setopt auto_menu
setopt auto_pushd
setopt complete_in_word
setopt extended_glob
setopt extended_history
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt inc_append_history
setopt interactive_comments
setopt no_beep
setopt prompt_subst
setopt pushd_ignore_dups
setopt pushd_silent
setopt share_history

unsetopt flow_control
unsetopt menu_complete

if (( ${+commands[nvim]} )); then
  export EDITOR="${EDITOR:-nvim}"
elif (( ${+commands[vim]} )); then
  export EDITOR="${EDITOR:-vim}"
elif (( ${+commands[nano]} )); then
  export EDITOR="${EDITOR:-nano}"
fi

export LESSHISTFILE=-
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less -FRX}"
if (( ${+commands[bat]} )); then
  export MANPAGER="${MANPAGER:-sh -c 'col -bx | bat -l man -p'}"
elif (( ${+commands[batcat]} )); then
  export MANPAGER="${MANPAGER:-sh -c 'batcat -l man -p'}"
fi
export DIRENV_LOG_FORMAT=
