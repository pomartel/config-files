function tmux-cours {
  local cours="$1"

  if [[ -z "$cours" ]]; then
    echo "Usage: tmux-cours <cours>"
    return 1
  fi

  local cours_dir="$HOME/Cours/$cours"

  if [[ ! -d "$cours_dir" ]]; then
    echo "Directory not found: $cours_dir"
    return 1
  fi

  if [[ -z $TMUX ]]; then
    tmux new-session -c "$cours_dir" "bash -ic 'tmux-cours \"$cours\"; exec bash'"
    return
  fi

  local ai_pane bash_pane md_pane

  ai_pane=$(tmux display-message -p '#{pane_id}')

  tmux split-window -h -p 30 -c "$cours_dir"
  bash_pane=$(tmux display-message -p '#{pane_id}')

  tmux select-pane -t "$bash_pane"
  tmux split-window -v -p 50 -c "$cours_dir"
  md_pane=$(tmux display-message -p '#{pane_id}')

  tmux send-keys -t "$md_pane" "watchmd $cours" C-m
  tmux send-keys -t "$ai_pane" "c ." C-m

  tmux select-pane -t "$ai_pane"
}

function tmux-blog {
  local work_dir="$HOME/Work/sudomarchy"

  if [[ -z $TMUX ]]; then
    tmux new-session -c "$work_dir" "bash -ic 'tmux-blog; exec bash'"
    return
  fi

  local ai_pane bash_pane git_pane npm_pane

  ai_pane=$(tmux display-message -p '#{pane_id}')

  tmux split-window -v -p 15 -c "$work_dir"
  bash_pane=$(tmux display-message -p '#{pane_id}')

  tmux select-pane -t "$ai_pane"
  tmux split-window -h -p 50 -c "$work_dir"
  git_pane=$(tmux display-message -p '#{pane_id}')

  tmux select-pane -t "$bash_pane"
  tmux split-window -h -p 50 -c "$work_dir"
  npm_pane=$(tmux display-message -p '#{pane_id}')

  tmux send-keys -t "$ai_pane" "opencode" C-m
  tmux send-keys -t "$git_pane" "lazygit" C-m
  tmux send-keys -t "$npm_pane" "npm run dev" C-m

  tmux select-pane -t "$ai_pane"
}
