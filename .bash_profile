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
export PATH="$HOME/.local/bin:$PATH"

# cd path
export CDPATH="$HOME/symlinks"

# history time stamp
export HISTTIMEFORMAT="%F %T     "

# tools
export VISUAL="/usr/bin/nvim"
export EDITOR="/usr/bin/nvim"
export LESS="$LESS -F -i -J -W -Q -R -x4 -z-4"

if (( $(less --version | head -n 1 | tr -dc '0-9') < 530 ))
then
    export LESS="$LESS -X"
fi

# Use $EDITOR for vi-inspired editors
alias nvim="$EDITOR"
alias vim="$EDITOR"
alias vi="$EDITOR"

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

# start
start () {
    if [[ -z "$1" ]]
    then
        printf "start: missing argument\n"
        return
    fi
    path="$(realpath "$1")"
    path="${path//\//\\}"
    if [[ "${path:0:5}" == '\mnt\' ]]
    then
        path="${path:5}"
        if [[ "$path" == *'\'* ]]
        then
            path="$(echo "$path" | sed -r 's/\\/:\\/')"
        else
            path="$path:"
        fi
    else
        path="\\\\wsl$\\Ubuntu$path"
    fi
    cmd.exe /C start "$path" 2> /dev/null
}
alias start=start

if [ -f "$HOME/.bash_extra" ]
then
    . "$HOME/.bash_extra"
fi
