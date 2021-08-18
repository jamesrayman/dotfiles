if [ -f "$HOME/.bashrc" ]
then
    source "$HOME/.bashrc"
fi

# set pythonrc
export PYTHONSTARTUP="$HOME/.pythonrc"

# python path
export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.6/site-packages/"
export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.8/site-packages/"
export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.9/site-packages/"

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

# Use $VISUAL for vi-inspired editors
alias nvim="$VISUAL"
alias vim="$VISUAL"
alias vi="$VISUAL"
alias ex="$VISUAL -e"
alias view="$VISUAL -R"
alias rvim="$VISUAL -Z"
alias rview="$VISUAL -R -Z"
alias vimdiff="$VISUAL -d"

# less
export PAGER="less"
export LESS="-F -i -J -W -Q -R -x4 -z-4"
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_ue=$'\e[0m'

# man
export MANWIDTH=78

# fzf
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_DEFAULT_OPTS="--height=40% --info=inline --border"
source "$HOME/.fzfrc"

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
