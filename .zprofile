if [ -z "$TMUX" ]
then
    tmux attach -t main || tmux new -s main
fi

export VISUAL=nvim
export EDITOR="$VISUAL"

# movio specific
[ -f ~/.movio/movio.bash ] && source ~/.movio/movio.bash
[ -f ~/.git-prompt.sh ] && source ~/.git-prompt.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.git-completion.zsh ] && source ~/.git-completion.zsh

eval "$(jump shell)"
eval "$(jump shell --bind=z)"

setopt PROMPT_SUBST
PS1='%m %15<...<%~%<< $(__git_ps1 "(%s)") \$ '

bindkey '^ ' _git-status

# use n as main editor trigger argument decides focus state
function n {
  if [[ -n "$1" ]]; then
    nvim $1
  else
    nvim .
  fi
}

function _git-status { lazygit }
zle -N _git-status

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # nvm bash_completion

# load git completion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

autoload -Uz compinit && compinit
