if [ "$TMUX" = "" ]; then tmux attach -t main || tmux new -s main; fi

autoload -Uz colors && colors
autoload -Uz vcs_info
autoload -Uz compinit && compinit
autoload -Uz edit-command-line

eval "$(jump shell)"
eval "$(pyenv init -)"

function n { if [[ -n "$1" ]]; then nvim $1; else nvim .; fi }
function _lazygit { lazygit; zle reset-prompt }

export HISTSIZE=30000
export SAVEHIST=30000
export HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY

export FZF_CTRL_R_OPTS='--layout reverse'
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*" '

export PYENV_VERSION="3.8.0"

bindkey -e # set emacs bindings

zle -N _lazygit
bindkey '^@' _lazygit

export EDITOR=nvim
zle -N edit-command-line
bindkey "^X^E" edit-command-line

bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word

export EDITOR="nvim"
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
PROMPT="%{$fg[white]%}[%D{%H:%M:%S}] %B%{$fg[yellow]%}%m:%b%{$fg[blue]%}%(1~|%30<...<%~%<<|%~)%{$reset_color%}"\$vcs_info_msg_0_" %% "
zstyle ':vcs_info:git:*' formats '(%b)'

case $TERM in
  xterm*)
    precmd () {print -Pn "\e]0;%(2~|%15<...<%~%<<|%~)\a"}
    ;;
esac

[ -f ~/.movio/movio.sh ] && source ~/.movio/movio.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

zstyle ':completion:*' menu select

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
