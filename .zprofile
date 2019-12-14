if [ "$TMUX" = "" ]; then tmux attach -t main || tmux new -s main; fi

autoload -Uz colors && colors
autoload -Uz vcs_info
autoload -Uz compinit && compinit

eval "$(jump shell)"
eval "$(pyenv init -)"

function n { if [[ -n "$1" ]]; then nvim $1; else nvim .; fi }
function _git-status { lazygit; zle reset-prompt }

export HISTSIZE=30000
export SAVEHIST=30000
export HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY

export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*" '
export FZF_CTRL_R_OPTS='--layout reverse'

export PYENV_VERSION=3.8.0

zle -N _git-status
bindkey '^ ' _git-status
bindkey -e

bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word

export EDITOR="nvim"
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
PROMPT="%B%{$fg[yellow]%}%m:%b%{$fg[blue]%}%(1~|%30<...<%~%<<|%~)%{$reset_color%}"\$vcs_info_msg_0_" %% "
zstyle ':vcs_info:git:*' formats '(%b)'

[ -f ~/.movio/movio.sh ] && source ~/.movio/movio.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

zstyle ':completion:*' menu select

