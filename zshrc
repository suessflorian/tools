autoload -Uz compinit && compinit

cdpath=($HOME/Documents)

export EDITOR=nvim
bindkey -e

export HISTFILE=~/.zsh_history
export HISTSIZE=30000
export SAVEHIST=30000

export HISTORY_IGNORE="(ls|pwd|cd *|exit|rm *)"
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

source "/usr/local/opt/fzf/shell/key-bindings.zsh"
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*" '

function _open { nvim . }
zle -N _open
bindkey '^X^O' _open

function _notes { nvim  -c "+normal ggO# $(date)" ~/.notes.md }
zle -N _notes
bindkey '^X^N' _notes

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

function _lazygit { lazygit }
zle -N _lazygit
bindkey "^@" _lazygit

export GOPATH=$HOME/Documents/go
export PATH=$GOPATH/bin:$PATH

autoload -U colors && colors
PROMPT="%{$fg[blue]%}%1| %2~ %{$reset_color%}%# "

[ -f ~/.movio/movio.sh ] && source ~/.movio/movio.sh
