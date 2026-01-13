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
# trap 'echo -ne "\033]2;$(history 1 | sed "s/^[ ]*[0-9]*[ ]*//g")\007"' DEBUG

alias reload="source $HOME/.bashrc"
alias y=yadm
alias z=zeditor
alias lg=lazygit
alias timestamp="date +%s"

# Work
export POLL_PATH="$HOME/Work/poll-app"
alias po="cd $POLL_PATH"
alias site="cd $HOME/Work/poll-app.com/"
alias cr="cd $HOME/Work/coderubik.com/"

alias mm="target=poll bundle exec middleman"
alias rdb="rails db:migrate"
alias rdbr="rails db:rollback"
alias rs="./bin/dev"

# Blog
alias jk="bundle exec jekyll serve --livereload"
alias bg="cd $HOME/Work/sudomarchy/"

# Teaching
export COURS_PATH="$HOME/Cours"
alias cours="cd $COURS_PATH"
alias sp="cd $COURS_PATH/serveur-prof"
alias md="cd $HOME/Work/markdown"
alias watchmd="$HOME/Work/markdown/scripts/watch_changes"

alias sshp="ssh po@serveurprof.com -p 143"
alias sshu="ssh u1234567@serveurprof.com -p 143"

deploy() {
  for t in "$@"; do
    echo "---- Deploying to $t ----"
    git push $t +HEAD:master
  done
}

mmbuild() {
  case $1 in
  cr) targets=(coderubik) ;;
  en) targets=(poll survey contest quiz) ;;
  fr) targets=(sondage concours) ;;
  es) targets=(encuesta concurso) ;;
  pt) targets=(enquete promocao) ;;
  de) targets=(umfrage gewinnspiel) ;;
  all) targets=(poll survey contest quiz sondage concours encuesta concurso enquete promocao umfrage gewinnspiel) ;;
  *) targets=($1) ;;
  esac

  for t in "${targets[@]}"; do
    echo "Deploying Middleman site for $t"
    target=$t bundle exec middleman build
    target=$t bundle exec middleman s3_sync
    target=$t bundle exec middleman invalidate
  done
}
