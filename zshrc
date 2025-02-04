if [[ `uname -m` == 'arm64' ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
autoload -Uz compinit && compinit

precmd () {print -Pn "\e]0;%~\a"} # set shell process name to pwd

export VISUAL="nvim"
export EDITOR="nvim"

bindkey -e

export HISTFILE=~/.zsh_history
export HISTSIZE=30000
export SAVEHIST=30000

export HISTORY_IGNORE="(open|ls|pwd|cd *|z *|exit|rm *|git *|cp *|mkdir *|mv *|ls *|nvim *)"
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

function _open { nvim }
zle -N _open
bindkey '^X^O' _open

function _notes { nvim ~/.notes.md }
zle -N _notes
bindkey '^X^N' _notes

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

alias lazygit="lazygit -ucd ~/.config/lazygit"
function _lazygit { lazygit }
zle -N _lazygit
bindkey "^@" _lazygit # control space

PROMPT="%1| %2~ %# "

[ -f ~/.vend/vend.sh ] && source ~/.vend/vend.sh
[ -f ~/.vend/home/functions.sh ] && source ~/.vend/home/functions.sh

export GOPATH=$HOME/Documents/go
export PATH=$GOPATH/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*" '

source /opt/homebrew/etc/profile.d/z.sh

alias ls='ls -GFahl'
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
