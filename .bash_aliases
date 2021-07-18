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
        local com="$(fc -ln "-$i" "-$i")"  # TODO: make this only one subshell call
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

# xx is cd but search recursively from /
# By default, prefixes are matched, not entire names. To override this
# behavior, add a / to the end of any argument
# If multiple arguments are given, then it's as if every argument was
# given to xx individually, except if the first argument starts with /,
# it is executed as a normal cd.
#
# Examples: below is a matrix of commands and directories specifying
# which directories are checked by each command
# /var/run
# /var/tmp/run
# /var/tmp/run/abc
# /var/tmp/runnable/abc
# /var/abc/xyz/runner
# /usr/variable/runnable
# /lib/run
# /Var/run
# /run/var
xx() {
    if [[ -z "$1" ]]
    then
        printf '%s\n' "xx: missing argument"
        return 1
    fi

    local reg=""
    local pat=""

    if [[ "$1" == /* ]]
    then
        reg="^"
    else
        pat="*"
    fi

    local arg
    for arg in "${@:1}"
    do
        if [[ "$arg" == /* ]]
        then
            arg="${arg:1}"
        fi

        reg="$reg(/|(?<=/))$arg.*"
        pat="$pat/${arg%"/"}*"
    done
    reg="${reg%".*"}"

    if [[ "$reg" == */ ]]
    then
        reg="$reg$"
        pat="${pat%"/*"}"
    else
        reg="$reg[^/]*/$"
    fi

    local dir
    local dirs=()
    while IFS= read -d $'\0' -r dir
    do
        if [[ -d "$dir" ]] && grep -q -P "$reg" <<< "$dir/"
        then
            dirs+=("$dir")
        fi
    done < <(locate -e -0 "$pat")

    if [[ "${#dirs[@]}" == 1 ]]
    then
        cd "${dirs[0]}"
    elif [[ "${#dirs[@]}" == 0 ]]
    then
        printf '%s\n' "xx: no matching directories found"
    else
        printf '%s\n' "${dirs[@]:0:10}"
    fi
}

# x is xx but only from the current directory
x() {
    if [[ -z "$1" ]]
    then
        printf '%s\n' "x: missing argument"
        return 1
    fi

    xx "$PWD/" "$@"
}
