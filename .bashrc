# TODO: reorganize
# TODO: update ls colors

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary, update the
# values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]
then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null
then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
else
    color_prompt=
fi


if [[ -f '/usr/share/git/completion/git-prompt.sh' ]]
then
    source '/usr/share/git/completion/git-prompt.sh'
fi
GIT_PS1_SHOWDIRTYSTATE=y
GIT_PS1_SHOWUNTRACKEDFILES=y
GIT_PS1_SHOWUPSTREAM=auto
PS1=''

if [[ "$color_prompt" = yes ]]
then
    GIT_PS1_SHOWCOLORHINTS=y
    PROMPT_COMMAND='__git_ps1 "\[\e[0;36m\][\t]\[\e[0m\] ${debian_chroot:+($debian_chroot)}\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\w\e[0m\]" "\$ "'
else
    PROMPT_COMMAND='__git_ps1 "[\t] ${debian_chroot:+($debian_chroot)}\u@\h:\w" "\$ "'
fi



# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]
then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features
if ! shopt -oq posix
then
    if [ -f /usr/share/bash-completion/bash_completion ]
    then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]
    then
        . /etc/bash_completion
    fi
fi

# XDG
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# STTY
stty erase '^?'
stty werase ''  # Allow .inputrc to bind ^W
stty -ixon      # Disable ^S and ^Q flow control

# inputrc
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

# GPG
export GPG_TTY="$(tty)"

# set pythonrc
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"

# Python path
export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.9/site-packages/"
export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.8/site-packages/"
export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.6/site-packages/"

# Rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# Bash
export HISTFILE="$XDG_STATE_HOME/bash/history"

# make ls prettier
export LS_COLORS="$LS_COLORS:ow=1;34;35:tw=1;34;35"

# misc path
export PATH="$HOME/.local/bin:$HOME/bin:$PATH:$CARGO_HOME/bin"

for bin_dir in "$HOME"/Projects/*/bin/ "$HOME"/Projects/misc/*/bin/
do
    PATH="$PATH:$bin_dir"
done


# quick links with cd
CDPATH="$HOME/symlinks"

# history time stamp
HISTTIMEFORMAT="%F %T     "

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
export LESS="-F -i -Q -R -z-4"
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESSHISTFILE="$XDG_STATE_HOME/less/history"

if (( $(less --version | head -n 1 | tr -dc '0-9') < 530 ))
then
    export LESS="$LESS -X"
fi

# man
export MANWIDTH=78


# fzf
export FZF_DEFAULT_OPTS="--height=40% --info=inline --border --select-1 --exit-0 --no-mouse"
export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type directory"
export FZF_CTRL_T_OPTS="--preview='preview {}'"
export FZF_ALT_C_OPTS="--preview='preview {}'"
_fzf_compgen_path() {
    echo "$1"
    $FZF_DEFAULT_COMMAND "$1"
}
_fzf_compgen_dir() {
    $FZF_ALT_C_COMMAND "$1"
}
export FZF_COMPLETION_TRIGGER=","
PATH="$PATH:$HOME/src/fzf/bin"
source "$XDG_CONFIG_HOME/fzf/fzfrc"

# Ruby
export GEM_HOME="$XDG_DATA_HOME/gem"
export PATH="$GEM_HOME/bin:$PATH"

export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"

# Node
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node/history"

# NVM
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ICE
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"

# Sage
export DOT_SAGE="$XDG_CONFIG_HOME/sage"

# Asymptote
export ASYMPTOTE_HOME="$XDG_CONFIG_HOME/asy"

# Jupyter
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"

# Opam
export OPAMROOT="$XDG_DATA_HOME/opam"
test -r "$OPAMROOT/opam-init/init.sh" && . "$OPAMROOT/opam-init/init.sh" &> /dev/null || true

# shell options

# evaluate symlinks immediately
set -P

set enable-bracketed-paste on
shopt -s globstar
shopt -s nullglob

# makefile
export CPPFLAGS="-Wall -std=c++17"
export JAVAC="javac"

# make with custom defaults
m() {
    MAKEFILES="$XDG_CONFIG_HOME/make/makefile" make all "$@"
}

# alias python3
hash python3.9 &>/dev/null && alias python="python3.9"
hash python3.8 &>/dev/null && alias python="python3.8"
hash python3 &>/dev/null && alias python="python3"
alias pip="pip3"

# consistent with autocd
alias -- -='cd -'
alias ..='cd ..'

# safety
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# ls
alias la='command ls -laGhv --group-directories-first --color=auto'
alias l='command ls -v --group-directories-first --color=auto'
alias ls='ls -lGhv --group-directories-first --color=auto'

# other
alias more="less"
alias mutt="neomutt"

# color diff by default
alias diff='diff --color'

# weather
alias weather='curl -sSL https://wttr.in | head -n -2'

# aliases to force XDG compliance
alias units='units --history "$XDG_STATE_HOME/units/history"'
alias wget='wget --hsts-file "$XDG_STATE_HOME/wget/hsts"'

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


f_r_i() {
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
# r git pull
# fc -s 'git pull'
r() {
    local i="$(f_r_i "$@")"

    if [[ $i == 1 ]]
    then
        fc -s "$*";
    else
        fc -s "${@:1:$(( i-1 ))}" "${*:$i}"
    fi
}

# Like r, but doesn't execute the command
vr() {
    local sub_end="$(f_r_i "$@")"
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

    printf "vr: no command found\n"
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


# any extra machine-dependent stuff
if [ -f "$HOME/.bash_extra" ]
then
    source "$HOME/.bash_extra"
fi

