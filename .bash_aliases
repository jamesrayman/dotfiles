# alias python3
hash python3.9 &>/dev/null && alias python="python3.9"
hash python3.8 &>/dev/null && alias python="python3.8"
hash python3 &>/dev/null && alias python="python3"
alias pip="pip3"

# consistent with autocd
alias -- -='cd -'
alias ..='cd ..'

# ls
alias la='command ls -laGhv --group-directories-first --color=auto'
alias l='command ls -v --group-directories-first --color=auto'
alias ls='ls -lGhv --group-directories-first --color=auto'

# other
alias more="less"
alias q="exit"
alias mutt="neomutt"

# Evaluate args, print them, and add them to history, but don't execute
# them
v() {
    history -s "$@"
    printf "%s\n" "$*"
}

# Always pass the -E flag to sudo. Also, if no arguments are given, use
# the last command
_sudo() {
    local prev="$(fc -ln -1)"
    prev="${prev#"${prev%%[![:space:]]*}"}"
    if (( $# == 0 ))
    then
        v "sudo $prev"
        command sudo -E $prev
    else
        command sudo -E "$@"
    fi
}
alias sudo="_sudo"

# Alias for history. Prints 10 entries by default
h() {
    history "${1-10}"
}


f_re_i() {
    local i=1

    local arg
    for arg in "$@"
    do
        if [[ ! "$arg" =~ = ]]
        then
            printf "$i"
            return
        fi
        (( i++ ))
    done

    printf "$i"
}

# Like fc -s, but all non-substitution arguments are combined
# For example, the following two commands are equivalent
# re git pull
# fc -s 'git pull'
re() {
    local i="$(f_re_i "$@")"

    if [[ $i == 1 ]]
    then
        fc -s "$*";
    else
        fc -s "${@:1:$(( i-1 ))}" "${*:$i}"
    fi
}

# Like re, but doesn't execute the command
vre() {
    local sub_end="$(f_re_i "$@")"
    local query="${*:$sub_end}"
    local n="$(history | wc -l)"

    local i
    for (( i=1; i <= n; i++ ))
    do
        local com="$(fc -ln "-$i" "-$i")"
        com="${com#"${com%%[![:space:]]*}"}"

        if [[ "$com" == "$query"* ]]
        then
            if [[ $sub_end != 1 ]]
            then
                local sub
                for sub in "${@:1:$(( sub_end-1 ))}"
                do
                    local pre="${sub%%=*}"
                    local post="${sub#*=}"
                    com=${com//"$pre"/"$post"}
                done
            fi

            v "$com"
            return
        fi
    done

    printf "vre: no command found\n"
}

# git alias. git s is used if arguments are given
g() {
    if (( $# == 0 ))
    then
        git s
    else
        git "$@"
    fi
}
