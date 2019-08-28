export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/floriansuess/.oh-my-zsh"

CASE_SENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=250"

plugins=(git z zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[white]%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_no_bold[red]%}*"

PROMPT='  %{$fg[white]%}%30<...<%~%<<%{$reset_color%}$(git_prompt_info): '

# preferred editor
export EDITOR='nvim'

if [ -z "$TMUX" ]
then
    TERM=screen-256color
    tmux attach -t main || tmux new -s main
fi

# alias's and functions
n() { nvim "${1:-.}"; }
source ~/.awsAliases
alias aws.all="_awsListAll"
alias aws.lp="_awsListProfile"
alias aws.who="aws configure list"

alias kubectl.dev.fs="kubectl.dev -n=mc-red-fs"

function aws.p () {
    iam check $1 && eval $(iam export $1)
}

function aws.ecr.login () {
    iam check movio-dev && eval $(iam export movio-dev)
    $(aws ecr get-login --no-include-email --region us-east-1 --registry-ids 191213556404)
}

export GOPATH="$HOME/Documents/gopath"
export GOROOT="/usr/local/opt/go/libexec"
export PATH="$PATH:$GOPATH/bin"

# emacs style terminal io bindings
bindkey -e

#   ctrl + u          : clear line
#   ctrl + w          : delete word backward
#   ctrl + a          : move to beginning of line
#   ctrl + e          : move to end of line (e for end)
#   ctrl + f/b        : move back or forward
#   ctrl + d          : delete char at current position (d for delete)
#   alt + left/right  : move back or forward

# ctrl+b/f or alt+left/right : move word by word (backward/forward)
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
bindkey '^f' forward-word
bindkey '^b' backward-word

# ctrl+space brings up git status window
bindkey -s '^ ' 'lazygit^M'

export PATH="$PATH:/Users/floriansuess/Library/Python/3.7/bin"
export PATH="$PATH:/Users/floriansuess/Library/Python/2.7/bin"
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"
