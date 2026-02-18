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
		tmux new-session "bash -ic 'source ~/.config/tmux/functions.sh; tmux-cours \"$cours\"; exec bash'"
		return
	fi

	local main_pane right_top_pane right_bottom_pane

	main_pane=$(tmux display-message -p '#{pane_id}')

	tmux split-window -h -p 30 -c "$cours_dir"
	right_top_pane=$(tmux display-message -p '#{pane_id}')

	tmux select-pane -t "$right_top_pane"
	tmux split-window -v -p 50 -c "$cours_dir"
	right_bottom_pane=$(tmux display-message -p '#{pane_id}')

	tmux send-keys -t "$right_bottom_pane" "watchmd $cours" C-m
	tmux send-keys -t "$main_pane" "cd \"$cours_dir\" && c ." C-m

	tmux select-pane -t "$main_pane"
}

function tmux-blog {
	local work_dir="$HOME/Work/sudomarchy"

	if [[ ! -d "$work_dir" ]]; then
		echo "Directory not found: $work_dir"
		return 1
	fi

	if [[ -z $TMUX ]]; then
		tmux new-session "bash -ic 'source ~/.config/tmux/functions.sh; tmux-blog; exec bash'"
		return
	fi

	local top_left_pane bottom_left_pane top_right_pane bottom_right_pane

	top_left_pane=$(tmux display-message -p '#{pane_id}')

	tmux split-window -v -p 15 -c "$work_dir"
	bottom_left_pane=$(tmux display-message -p '#{pane_id}')

	tmux select-pane -t "$top_left_pane"
	tmux split-window -h -p 30 -c "$work_dir"
	top_right_pane=$(tmux display-message -p '#{pane_id}')

	tmux select-pane -t "$bottom_left_pane"
	tmux split-window -h -p 30 -c "$work_dir"
	bottom_right_pane=$(tmux display-message -p '#{pane_id}')

	tmux send-keys -t "$top_left_pane" "cd \"$work_dir\" && nvim ." C-m
	tmux send-keys -t "$top_right_pane" "cd \"$work_dir\" && opencode" C-m
	tmux send-keys -t "$bottom_right_pane" "cd \"$work_dir\" && npm run dev" C-m

	tmux select-pane -t "$top_left_pane"
}
