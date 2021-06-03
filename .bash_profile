if [ -f "$HOME/.bash_extra" ]
then
    . "$HOME/.bash_extra"
fi

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

# tools
export VISUAL="vim"
export EDITOR="vim"
export LESS="$LESS -Q -R"

# maven
export JAVA_HOME="/usr/lib/jvm/java-15-oracle"
export PATH="$PATH:/mnt/c/tools/apache-maven-3.6.3/bin"

# cd with $WINHOME
cd_plus () {
    args=()
    for arg in "$@"
    do
        if [[ "${arg:0:1}" == "+" ]]
        then
            args+=("$WINHOME${arg:1}")
        else
            args+=("$arg")
        fi
    done

    command cd "${args[@]}"
}
alias cd=cd_plus

# start
start () {
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

