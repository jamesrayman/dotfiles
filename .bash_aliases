# use Python 3 by default
alias python2="command python"
alias python="python3"
alias pip2="command pip"
alias pip="pip3"

# other
alias sudo='sudo -E'
alias more="less"
alias :q="exit"

# Evaluate args, print them, and add them to history, but don't execute
# them
v() {
    history -s "$@"
    printf "%s\n" "$*"
}

# Redo the last command with sudo and put it in the history as such
rs() {
    local prev="$(fc -ln -1)"
    prev="${prev#"${prev%%[![:space:]]*}"}"
    v "sudo $prev"
    sudo $prev
}

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
