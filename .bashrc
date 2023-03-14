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

if [[ -f '/usr/share/git/completion/git-prompt.sh' ]]
then
    source '/usr/share/git/completion/git-prompt.sh'
fi
GIT_PS1_SHOWDIRTYSTATE=y
GIT_PS1_SHOWUNTRACKEDFILES=y
GIT_PS1_SHOWUPSTREAM=auto
PS1=''
GIT_PS1_SHOWCOLORHINTS=y
PROMPT_COMMAND='__git_ps1 "\[\e[0;36m\][\t]\[\e[0m\] ${debian_chroot:+($debian_chroot)}\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\w\e[0m\]" "\$ "'

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features
if ! shopt -oq posix
then
    if [[ -f /usr/share/bash-completion/bash_completion ]]
    then
        source /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]
    then
        source /etc/bash_completion
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
export LESS_TERMCAP_vb=$'\x7f'
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export LESSKEYIN="$XDG_CONFIG_HOME/less/lesskey"

# man
export MANWIDTH=78

# fzf
export FZF_DEFAULT_OPTS="--height=40% --info=inline --border --select-1 --exit-0 --no-mouse"
export FZF_DEFAULT_COMMAND='idfs --hidden --follow --exclude .git --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type directory"
export FZF_CTRL_T_OPTS="--preview='preview {}' --scheme=path"
export FZF_CTRL_R_OPTS="--scheme=history"
export FZF_ALT_C_OPTS="--preview='preview {}' --scheme=path"
_fzf_compgen_path() {
    echo "$1"
    $FZF_DEFAULT_COMMAND "$1"
}
_fzf_compgen_dir() {
    $FZF_ALT_C_COMMAND "$1"
}
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
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

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
[ -r "$OPAMROOT/opam-init/init.sh" ] && source "$OPAMROOT/opam-init/init.sh" &> /dev/null || true

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
alias python="python3"
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
