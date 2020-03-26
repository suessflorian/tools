autoload -Uz compinit && compinit

eval "$(jump shell)"
eval "$(pyenv init -)"

export PYENV_VERSION="3.8.0"

export HISTSIZE=30000
export SAVEHIST=30000
export HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY

export FZF_CTRL_R_OPTS='--layout reverse'
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*" '

function _lazygit { lazygit; zle reset-prompt }
zle -N _lazygit
bindkey '^@' _lazygit

export EDITOR=nvim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

export PATH=$HOME/.cargo/bin:$PATH

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
autoload -Uz colors && colors
export PS1="%F{241}[%D{%H:%M:%S}] %B%F{214}%m%F{254}%b:%(1~|%20<...<%~%<<|%~)%B"\$vcs_info_msg_0_"%F{254}%b %% %{$reset_color%}"
zstyle ':vcs_info:git:*' formats ' (%b)'

case $TERM in
  xterm*)
    precmd () {print -Pn "\e]0;%(2~|%15<...<%~%<<|%~)\a"}
    ;;
esac

[ -f ~/.movio/movio.sh ] && source ~/.movio/movio.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
