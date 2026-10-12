if (( ${+commands[dircolors]} )); then
  eval "$(dircolors -b)"
fi

if (( ${+commands[batcat]} )) && (( ! ${+commands[bat]} )); then
  alias bat='batcat'
fi

if (( ${+commands[fdfind]} )) && (( ! ${+commands[fd]} )); then
  alias fd='fdfind'
fi

if (( ${+commands[eza]} )); then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -lh --git --group-directories-first --icons=auto'
  alias la='eza -lah --git --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --group-directories-first --icons=auto'
fi

alias c='clear'
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate --all'
alias gs='git status -sb'
alias lg='lazygit'
alias md='glow'
_fd=fd; (( ${+commands[fdfind]} )) && _fd=fdfind
export FZF_DEFAULT_COMMAND="$_fd --hidden --follow --exclude .git --strip-cwd-prefix"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$_fd --type d --hidden --follow --exclude .git --strip-cwd-prefix"
export FZF_DEFAULT_OPTS=$'--layout=reverse --height=55% --border=rounded --margin=1,2 --padding=1 --info=inline-right --prompt=  --pointer= --marker=󰄾 --color=fg:#e6e4e1,bg:#0c0c0c,hl:#73c991,fg+:#e6e4e1,bg+:#181818,hl+:#f6c177,info:#8a9aa5,prompt:#73c991,pointer:#c4b5fd,marker:#f39660,spinner:#73c991,header:#8a9aa5'
export FZF_CTRL_T_OPTS=$'--preview \'if [ -d {} ]; then eza --all --color=always --group-directories-first --icons=always --long {}; else bat --color=always --style=plain --line-range=:220 {}; fi\''
export FZF_ALT_C_OPTS=$'--preview \'eza --all --color=always --group-directories-first --icons=always --long {}\''
