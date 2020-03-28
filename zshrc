autoload -Uz compinit && compinit

eval "$(jump shell)"

export EDITOR=nvim

export HISTSIZE=30000
export SAVEHIST=30000
export HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY

source "/usr/local/opt/fzf/shell/key-bindings.zsh"
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*" '

function _lazygit { lazygit; zle reset-prompt }
zle -N _lazygit
bindkey '^X^G' _lazygit

function _open { nvim . }
zle -N _open
bindkey '^X^O' _open

function _notes { nvim  -c "+normal ggO# $(date)" -c ':s/$/\r/' ~/.notes.md }
zle -N _notes
bindkey '^X^N' _notes

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# supporting Go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# supporting Rust
export PATH=$HOME/.cargo/bin:$PATH

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
autoload -Uz colors && colors
export PS1="%B%F{214}%m%F{254}%b:%(1~|%20<...<%~%<<|%~)%B"\$vcs_info_msg_0_"%F{254}%b %% %{$reset_color%}"
zstyle ':vcs_info:git:*' formats ' (%b)'

# setting session title to current directory
precmd () {print -Pn "\033]0;%c\007"}

[ -f ~/.movio/movio.sh ] && source ~/.movio/movio.sh
