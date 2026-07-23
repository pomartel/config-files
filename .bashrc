# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# /etc/omarchy.conf is written by omarchy-dev-link. When absent, force the
# package default instead of preserving a stale inherited dev-link value before
# we decide which rc file to source.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH=/usr/share/omarchy
fi
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# Add user scripts to PATH
export PATH=$HOME/bin:$PATH

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
export POLL_PATH="$HOME/Projects/poll-app"

alias po="cd $POLL_PATH"
alias site="cd $HOME/Projects/poll-app.com/"
alias cr="cd $HOME/Projects/coderubik.com/"
alias mm="target=poll bundle exec middleman"
alias rdb="rails db:migrate"
alias rdbr="rails db:rollback"
alias rs="./bin/dev"

# Omarchy
alias bg="cd $HOME/Projects/sudomarchy/"

# Teaching
export COURS_PATH="$HOME/Cours"

alias cours="cd $COURS_PATH"
alias sp="cd $COURS_PATH/serveur-prof"
alias md="cd $HOME/Projects/markdown"
alias watchmd="$HOME/Projects/markdown/scripts/watch_changes"
alias sshp="ssh po@serveurprof.com -p 143"
alias sshu="ssh u1234567@serveurprof.com -p 143"
