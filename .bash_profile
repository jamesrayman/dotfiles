if [ -f "$HOME/.bashrc" ]
then
    source "$HOME/.bashrc"
fi

# set pythonrc
export PYTHONSTARTUP="$HOME/.pythonrc"

# python path
export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.6/sitepackages/"

# make ls prettier
export LS_COLORS="$LS_COLORS:ow=1;34;35:tw=1;34;35"

# misc path
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

if [[ -v WSL ]]
then
    for bin_dir in "$WH"/Projects/*/bin/
    do
        PATH="$PATH:$bin_dir"
    done
else
    for bin_dir in "$HOME"/Projects/*/bin/
    do
        PATH="$PATH:$bin_dir"
    done
fi


# cd path
export CDPATH="$HOME/symlinks"

# history time stamp
export HISTTIMEFORMAT="%F %T     "

# visual and editor
export VISUAL="/usr/bin/nvim"
export EDITOR="$VISUAL"

# less
export PAGER="less"
export LESS="-F -i -J -W -Q -R -x4 -z-4"
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export LESS_TERMCAP_ue=$'\E[0m'

if (( $(less --version | head -n 1 | tr -dc '0-9') < 530 ))
then
    export LESS="$LESS -X"
fi

# man
export MANWIDTH=78

# Use $VISUAL for vi-inspired editors
alias nvim="$VISUAL"
alias vim="$VISUAL"
alias vi="$VISUAL"
alias ex="$VISUAL -e"
alias view="$VISUAL -R"
alias rvim="$VISUAL -Z"
alias rview="$VISUAL -R -Z"
alias vimdiff="$VISUAL -d"

# fasd
source .fasdrc


# shell options

# evaluate symlinks immediately
set -P

set enable-bracketed-paste on
shopt -s globstar
shopt -s nullglob
shopt -s autocd


if [ -f "$HOME/.bash_extra" ]
then
    source "$HOME/.bash_extra"
fi
