autoload -Uz compinit && compinit

eval "$(jump shell)"

export EDITOR=nvim
bindkey -e

export HISTSIZE=30000
export SAVEHIST=30000
export HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY

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

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

autoload -U promptinit && promptinit
prompt pure
PURE_GIT_DOWN_ARROW='⇣'
PURE_GIT_UP_ARROW='⇡'
PURE_GIT_STASH_SYMBOL='⎶'
zstyle :prompt:pure:git:stash show yes

[ -f ~/.movio/movio.sh ] && source ~/.movio/movio.sh
