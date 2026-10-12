_bat=bat; (( ${+commands[batcat]} )) && _bat=batcat
zstyle ':fzf-tab:*' fzf-flags --height=65% --layout=reverse --border=rounded --preview-window=right,58%,border-left
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --all --color=always --group-directories-first --icons=always --long $realpath'
zstyle ':fzf-tab:complete:eza:*' fzf-preview 'eza --all --color=always --group-directories-first --icons=always --long $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza --all --color=always --group-directories-first --icons=always --long $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview "if [ -d \$realpath ]; then eza --all --color=always --group-directories-first --icons=always --long \$realpath; else $_bat --color=always --style=plain --line-range=:220 \$realpath; fi"
zstyle ':fzf-tab:*' switch-group ',' '.'

if [[ -o interactive ]] && [[ -t 0 ]] && [[ -t 1 ]] && [[ -z ${ZSH_EXECUTION_STRING:-} ]] && [[ -r ${XDG_DATA_HOME}/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh ]]; then
  source "${XDG_DATA_HOME}/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
fi
