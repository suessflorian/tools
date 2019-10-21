if [ -z "$TMUX" ]
then
    tmux attach -t main || tmux new -s main
fi

autoload -U colors && colors
autoload -Uz vcs_info
autoload -Uz compinit && compinit

eval "$(jump shell)"

function n {
  if [[ -n "$1" ]]; then
    nvim $1
  else
    nvim .
  fi
}

function _git-status {
    lazygit
    zle reset-prompt
}
zle -N _git-status
bindkey '^ ' _git-status
bindkey -e

export EDITOR="nvim"

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
PROMPT="%{$fg[yellow]%}%m:%{$fg[blue]%}%(1~|%30<...<%~%<<|%~)%{$reset_color%}"\$vcs_info_msg_0_" %% "
zstyle ':vcs_info:git:*' formats '(%b)'

[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.movio/movio.sh ] && source ~/.movio/movio.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#b3b3b3"

export PATH="/Users/floriansuess/Library/Python/3.7/bin:$PATH"

