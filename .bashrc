# TODO: reorganize

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# Check for WSL
if [[ -v WSL_DISTRO_NAME ]]
then
    export WSL="y"
fi

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

# set short path in prompt, using "+" to indicate Windows home
export WINHOME="/mnt/c/Users/jamsr"
export WH="$WINHOME"
short_wd () {
    wd="$PWD"
    if [[ "$wd" =~ ^$HOME ]]
    then
        wd="~${wd#"$HOME"}"
    fi

    if [[ "$wd" =~ ^$WINHOME ]]
    then
        wd="+${wd#"$WINHOME"}"
    fi
    printf "%s" "$wd"
}


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
    PROMPT_COMMAND='__git_ps1 "\[\e[0;36m\][\t]\[\e[0m\] ${debian_chroot:+($debian_chroot)}\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m$(short_wd)\e[0m\]" "\$ "'
else
    PROMPT_COMMAND='__git_ps1 "[\t] ${debian_chroot:+($debian_chroot)}\u@\h:$(short_wd)" "\$ "'
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

# Alias definitions.
if [ -f ~/.bash_aliases ]
then
    . ~/.bash_aliases
fi

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

# STTY
stty erase '^?'
stty werase ''  # Allow .inputrc to bind ^W
stty -ixon      # Disable ^S and ^Q flow control


# GPG
export GPG_TTY="$(tty)"

# set pythonrc
export PYTHONSTARTUP="$HOME/.pythonrc"

# python path
export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.9/site-packages/"
export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.8/site-packages/"
export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.6/site-packages/"

# make ls prettier
export LS_COLORS="$LS_COLORS:ow=1;34;35:tw=1;34;35"

# misc path
export PATH="$HOME/.local/bin:$HOME/bin:$PATH:$HOME/.cargo/bin"

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
export LESS="-F -i -J -W -Q -R -z-4"
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_ue=$'\e[0m'

if (( $(less --version | head -n 1 | tr -dc '0-9') < 530 ))
then
    export LESS="$LESS -X"
fi

# man
export MANWIDTH=78


# fzf
export FZF_DEFAULT_OPTS="--height=40% --info=inline --border --select-1 --exit-0"
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
PATH="$PATH:$HOME/.fzf/bin"
source "$HOME/.fzfrc"


# Ruby
export GEM_HOME="$HOME/.gems"
export PATH="$HOME/.gems/bin:$PATH"

# shell options

# evaluate symlinks immediately
set -P

set enable-bracketed-paste on
shopt -s globstar
shopt -s nullglob
shopt -s autocd


# any extra machine-dependent stuff
if [ -f "$HOME/.bash_extra" ]
then
    source "$HOME/.bash_extra"
fi
