# use Python 3 by default
alias python2="command python"
alias python="python3"
alias pip2="command pip"
alias pip="pip3"

# other
alias sudo='sudo -E'
alias more="less"
alias :q="exit"
alias re='f_re() { fc -s "$*" ; unset -f f_re; }; f_re'
