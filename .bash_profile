if [ -z "$TMUX" ]
then
    tmux attach -t main || tmux new -s main
fi

export VISUAL=nvim
export EDITOR="$VISUAL"

[ -f ~/.git-prompt.sh ] && source ~/.git-prompt.sh
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash

eval "$(jump shell)"
eval "$(jump shell --bind=z)"

# prompt configuration with git integration
cyan='\[\e[0;36m\]'
green='\[\e[0;32m\]'
red='\[\e[0;31m\]'
magenta='\[\e[0;35m\]'
fgcolor='\[\e[0m\]'
export PS1=${cyan}'\h'${fgcolor}':'${green}'$(__shortpath "\w" 30)'${red}'$(__git_ps1 "(%s)")'${magenta}'\$ '${fgcolor}
unset cyan green red magenta fgcolor

bind -x '"\C- ":"lazygit;"'

# use n as main editor trigger argument decides focus state
function n {
  if [[ -n "$1" ]]; then
    nvim $1
  else
    nvim .
  fi
}

# shorten a path in $1 to max of $2 characters, prepending a "..."
function __shortpath {
  if [[ ${#1} -gt $2 ]]; then
    len=$2+3
      echo "..."${1: -$len}
    else
      echo $1
    fi
}
