# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# Show current running process in tab title
trap 'echo -ne "\033]2;$(history 1 | sed "s/^[ ]*[0-9]*[ ]*//g")\007"' DEBUG

yca() {
  msg="${*:-config changes}"
  yadm commit -am "$msg" && yadm push
}

# Basic
export CODEX_HOME="$HOME/.config/codex"
alias c='codex --dangerously-bypass-approvals-and-sandbox'
alias reload="source $HOME/.bashrc"
alias y=yadm
alias z=zeditor
alias lg=lazygit
alias rm='trash'
alias cat='bat -pp'

# Work
alias po="cd $HOME/Work/poll-app"
alias site="cd $HOME/Work/poll-app.com/"
alias cr="cd $HOME/Work/coderubik.com/"
alias mm="target=poll bundle exec middleman"
alias rdb="rails db:migrate"
alias rdbr="rails db:rollback"
alias rs="./bin/dev"

# Omarchy
alias bg="cd $HOME/Work/sudomarchy/"
alias om="cd $OMARCHY_PATH"

# Teaching
export COURS_PATH="$HOME/Cours"
alias cours="cd $COURS_PATH"
alias sp="cd $COURS_PATH/serveur-prof"
alias md="cd $HOME/Work/markdown"
alias watchmd="$HOME/Work/markdown/scripts/watch_changes"
alias sshp="ssh po@serveurprof.com -p 143"
alias sshu="ssh u1234567@serveurprof.com -p 143"

if [[ -f "$HOME/.config/tmux/functions.sh" ]]; then
  source "$HOME/.config/tmux/functions.sh"
fi
