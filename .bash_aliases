# use Python 3 by default
alias python2="command python"
alias python="python3"
alias pip2="command pip"
alias pip="pip3"

# other
alias sudo='sudo -E'
alias more="less"
alias :q="exit"

f_re_i() {
    local i=1
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
alias re='f_re() { local i=$(f_re_i "$@"); if [[ $i == 1 ]]; then fc -s "$*"; else fc -s "${@:1:$(( i-1 ))}" "${*:$i}"; fi; unset -f f_re; }; f_re'
