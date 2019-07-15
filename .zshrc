
#    ███████╗███████╗██╗  ██╗██████╗  ██████╗
#    ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#      ███╔╝ ███████╗███████║██████╔╝██║     
#     ███╔╝  ╚════██║██╔══██║██╔══██╗██║     
# ██╗███████╗███████║██║  ██║██║  ██║╚██████╗
# ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
                                                                                                                                                                                                     
if [ -z "$TMUX" ]
then
    tmux attach -t main || tmux new -s main
fi
                                                                                        
export PATH=/Users/florians/.local/bin:$HOME/bin:/usr/local/bin:$PATH
export ZSH="/Users/florians/.oh-my-zsh"

plugins=(zsh-z zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

export EDITOR=nvim
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"

alias ls='ls -1AGp'
alias clear='clear && printf "\e[3J"'
alias rm.swp='rm ~/.local/share/nvim/swap/*'

alias git.delete.branches="git branch | grep -v 'master' | xargs git branch -D"

alias t='tig'
n() { nvim "${1:-.}"; }


source ~/.awsAliases
alias aws.all="_awsListAll"
alias aws.lp="_awsListProfile"
alias aws.who="aws configure list"

alias kubectl.dev="kubectl --context=movio-dev"
alias kubectl.dev.mm="kubectl --context=movio-dev -n=mm"
alias kubectl.dev.fs="kubectl --context=movio-dev -n=mc-red-fs"

alias go.mods.on='export GO111MODULE=on'
alias go.mods.auto='export GO111MODULE=auto'
alias go.mods.off='export GO111MODULE=off'

export NVM_DIR="$HOME/.nvm"
 [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
 [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export GOPATH="$HOME/Documents"
export GOROOT="/usr/local/opt/go/libexec"
export PATH="$PATH:$GOPATH/bin"

export PATH="$PATH:/Users/florians/Documents/others/heptio-authenticator-aws_0.3.0_linux_amd64"

prompt_dir() {
  prompt_segment blue black '%c'
}

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

local zle_sticked=""

zle-line-init() {
    BUFFER="$zle_sticked$BUFFER"
    zle end-of-line
}
zle -N zle-line-init

function zle-set-sticky {
    zle_sticked="$BUFFER"
    zle -M "Sticky: '$zle_sticked'."
}
zle -N zle-set-sticky
bindkey '^S' zle-set-sticky

function accept-line {
    if [[ -z "$BUFFER" ]] && [[ -n "$zle_sticked" ]]; then
        zle_sticked=""
        echo -n "\nRemoved sticky."
    fi
    zle .accept-line
}
zle -N accept-line

PROMPT=' %{$fg[white]%}%30<...<%~%<<%{$reset_color%}: '
RPROMPT='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}(%{$fg_no_bold[white]%}%B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%{$fg_bold[white]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}✱"

export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:'

# movio specifics
function aws.p () {
    iam check $1 && eval $(iam export $1)
}

function aws.ecr.login () {
    iam check movio-dev && eval $(iam export movio-dev)
    $(aws ecr get-login --no-include-email --region us-east-1 --registry-ids 191213556404)
}

function watchme {
  watch "$BUFFER"
}

zle -N watchme
bindkey '^T' watchme
