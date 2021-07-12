if [ -f "$HOME/.bashrc" ]
then
    . "$HOME/.bashrc"
fi

# set pythonrc
export PYTHONSTARTUP="$HOME/.pythonrc"

# python path
export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.6/sitepackages/"

# make ls prettier
export LS_COLORS="$LS_COLORS:ow=1;34;35:tw=1;34;35"

# misc path
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# cd path
export CDPATH="$HOME/symlinks"

# history time stamp
export HISTTIMEFORMAT="%F %T     "

# tools
export VISUAL="/usr/bin/nvim"
export EDITOR="$VISUAL"
export LESS="$LESS -F -i -J -W -Q -R -x4 -z-4"

if (( $(less --version | head -n 1 | tr -dc '0-9') < 530 ))
then
    export LESS="$LESS -X"
fi

# Use $VISUAL for vi-inspired editors
alias nvim="$VISUAL"
alias vim="$VISUAL"
alias vi="$VISUAL"
alias ex="$VISUAL -e"
alias view="$VISUAL -R"
alias rvim="$VISUAL -Z"
alias rview="$VISUAL -R -Z"

# maven
export JAVA_HOME="/usr/lib/jvm/java-15-oracle"
export PATH="$PATH:/mnt/c/tools/apache-maven-3.6.3/bin"

# shell options

# evaluate symlinks immediately
set -P

set enable-bracketed-paste on

# x is cd but search recursively
x () {
    if [[ -z "$1" ]]
    then
        printf "x: missing argument\n"
        return
    fi

    dirs=$(find . -type d -name "$1")
    dir_count="$(printf "$dirs\n" | wc -l)"
    
    if [[ "$dir_count" == 1 ]]
    then
        cd "$dirs"
    else
        printf "$dirs\n"
    fi
}


if [ -f "$HOME/.bash_extra" ]
then
    . "$HOME/.bash_extra"
fi
