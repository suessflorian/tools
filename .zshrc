export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/florians/.oh-my-zsh"

ZSH_THEME="robbyrussell"

CASE_SENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=250"

plugins=(git z zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

PROMPT='%{$fg[white]%}%30<...<%~%<<%{$reset_color%}: '
RPROMPT='$(git_prompt_info)'

# Preferred editor
export EDITOR='nvim'

if [ -z "$TMUX" ]
then
    tmux attach -t main || tmux new -s main
fi

# Alias's and functions
n() { nvim "${1:-.}"; }
source ~/.awsAliases
alias aws.all="_awsListAll"
alias aws.lp="_awsListProfile"
alias aws.who="aws configure list"
alias kubectl.dev="kubectl --context=movio-dev"
alias kubectl.dev.mm="kubectl --context=movio-dev -n=mm"
alias kubectl.dev.fs="kubectl --context=movio-dev -n=mc-red-fs"

function aws.p () {
    iam check $1 && eval $(iam export $1)
}

function aws.ecr.login () {
    iam check movio-dev && eval $(iam export movio-dev)
    $(aws ecr get-login --no-include-email --region us-east-1 --registry-ids 191213556404)
}

export NVM_DIR="$HOME/.nvm"
 [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export GOPATH="$HOME/Documents"
export GOROOT="/usr/local/opt/go/libexec"
export PATH="$PATH:$GOPATH/bin"

export PATH="$PATH:/Users/florians/Documents/others/heptio-authenticator-aws_0.3.0_linux_amd64"

# Emacs style terminal io bindings
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
bindkey -s '^ ' 'tig^M'
