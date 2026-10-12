[[ -o interactive ]] || return 0

setopt prompt_percent

for config_file in "$ZDOTDIR"/conf/*.zsh; do
  source "$config_file"
done

cc() {
  clear

  if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "cc — claude wrapper (auto-mode default, custom prompt, worktrees, teams)"
    echo ""
    echo "  cc                        auto mode + Anthropic's default prompt (default)"
    echo "  cc --custom-prompt        append personal prompt (~/.claude/system-prompt.md)"
    echo "  cc --yolo                 bypass ALL permission checks"
    echo "  cc --team                 enable agent teams (spawn teammates via Agent tool)"
    echo "  cc -w [name]              run in a git worktree, auto-merge on exit"
    echo "  cc --help                 show this help"
    echo ""
    echo "permission default comes from settings.json (permissions.defaultMode=auto)."
    echo "flags compose: cc --custom-prompt --team -w feat, cc --yolo, etc."
    echo "all other args pass through to claude."
    return 0
  fi

  local args=()
  local yolo=false
  local team=false
  local custom_prompt=false
  local worktree=""
  local i=1
  for arg in "$@"; do
    if [[ "$arg" == "--yolo" ]]; then
      yolo=true
    elif [[ "$arg" == "--team" ]]; then
      team=true
    elif [[ "$arg" == "--custom-prompt" ]]; then
      custom_prompt=true
    elif [[ "$arg" == "-w" ]]; then
      # Next arg is the worktree name (or auto-generate)
      worktree="${@[$((i+1))]:-$(date +%s | tail -c 6)}"
      shift
    elif [[ -n "$worktree" ]] && [[ "$arg" == "$worktree" ]]; then
      : # skip — already consumed as worktree name
    else
      args+=("$arg")
    fi
    ((i++))
  done

  # Anthropic's verbose default is the prompt for plain `cc`. --custom-prompt REPLACES it
  # with the lean personal prompt (~750 tok) via --system-prompt-file, dropping the ~4-7K
  # stock prompt AND Claude Code's dynamic cwd/env/git/memory-path sections (replace ignores
  # them). The personal prompt is self-contained (identity + tool/workflow/safety guidance);
  # CLAUDE.md and the memory index still inject as conversation context, so memory keeps working.
  if $custom_prompt; then
    args+=(--system-prompt-file "$HOME/.claude/system-prompt.md")
  fi

  # Auto-compact window. Anthropic ships a remote/clientdata default that compacts the
  # 1M Opus model at 500K (server-pushed, not from any local config — identical in every
  # fresh shell, which is why it can't be "found" in settings/env). Force the full 1M for
  # normal runs via CLAUDE_CODE_AUTO_COMPACT_WINDOW — the exact lever /context reports as
  # its source; the resolver clamps it to min(value, model-max). Only --team runs, which
  # spawn teammates and burn context fast, keep the leaner 500K.
  #
  # Pass everything as a command-line env prefix scoped to the claude PROCESS (via `env`),
  # never `export`ed — exporting would leak into the interactive shell and contaminate
  # later `cc` runs in the same terminal.
  local launch_env=(CLAUDE_CODE_AUTO_COMPACT_WINDOW=1000000)
  if $team; then
    launch_env=(CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 CLAUDE_CODE_AUTO_COMPACT_WINDOW=500000)
  fi

  if [[ -n "$worktree" ]]; then
    _cc_worktree "$worktree" "$yolo" "$team" "${args[@]}"
  elif $yolo; then
    env "${launch_env[@]}" claude --dangerously-skip-permissions "${args[@]}"
  else
    env "${launch_env[@]}" claude "${args[@]}"   # auto mode via permissions.defaultMode in settings.json
  fi
}

_cc_worktree() {
  local name="$1" yolo="$2" team="$3"
  shift 3
  local launch_env=(CLAUDE_CODE_AUTO_COMPACT_WINDOW=1000000)
  [[ "$team" == "true" ]] && launch_env=(CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 CLAUDE_CODE_AUTO_COMPACT_WINDOW=500000)
  local original_branch=$(git branch --show-current)
  local branch="tmp/wt-$name"
  local dir="/tmp/claude-wt/$name"

  git worktree add "$dir" -b "$branch" HEAD || return 1

  # Background npm install
  [ -f "$dir/package.json" ] && (cd "$dir" && npm install --silent &>/dev/null) &

  # Run claude in the worktree (env prefix scopes the autocompact/team vars to this process)
  if [[ "$yolo" == "true" ]]; then
    (cd "$dir" && env "${launch_env[@]}" claude --dangerously-skip-permissions "$@")
  else
    (cd "$dir" && env "${launch_env[@]}" claude "$@")
  fi

  # Auto-commit any uncommitted work
  if [ -n "$(git -C "$dir" status --porcelain 2>/dev/null)" ]; then
    git -C "$dir" add -A
    git -C "$dir" commit -m "wt/$name: auto-commit on exit"
  fi

  # Merge back if there are new commits
  if [ -n "$(git log "$original_branch..$branch" --oneline 2>/dev/null)" ]; then
    if git merge "$branch" --no-edit 2>/dev/null; then
      echo "✓ Merged worktree changes to $original_branch"
    else
      git merge --abort 2>/dev/null
      echo "✗ Merge conflict — branch '$branch' preserved. Resolve, then:"
      echo "  git worktree remove $dir && git branch -D $branch"
      return 1
    fi
  fi

  # Cleanup
  git worktree remove "$dir" --force 2>/dev/null
  git branch -D "$branch" 2>/dev/null
}

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"


# Auto-attach to tmux for interactive terminal shells.
# Guards: not already inside tmux, not a Claude Code tool shell, not over ssh,
# and only when stdin/stdout are a real terminal.
if [[ -o interactive && -z "$TMUX" && -z "$CLAUDECODE" && -z "$SSH_CONNECTION" && -t 0 && -t 1 ]] \
   && command -v tmux >/dev/null; then
  _tmux_free=$(tmux list-sessions -F "#{session_attached} #{session_name}" 2>/dev/null | awk '$1==0 {print $2; exit}')
  if [[ -n "$_tmux_free" ]]; then tmux attach -t "$_tmux_free"; else tmux new; fi
  unset _tmux_free
fi
