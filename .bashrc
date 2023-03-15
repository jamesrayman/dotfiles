# TODO: reorganize
# TODO: update ls colors

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# history
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
HISTFILE="$XDG_STATE_HOME/bash/history"
HISTTIMEFORMAT="%F %T     "

set -P
set enable-bracketed-paste on
shopt -s globstar
shopt -s nullglob
shopt -s checkwinsize

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

# Python
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
alias python="python3"
alias pip="pip3"

# Rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# make ls prettier
export LS_COLORS="$LS_COLORS:ow=1;34;35:tw=1;34;35"

# misc path
export PATH="$HOME/.local/bin:$HOME/bin:$PATH:$CARGO_HOME/bin"

for bin_dir in "$HOME"/Projects/*/bin/ "$HOME"/Projects/misc/*/bin/
do
    PATH="$PATH:$bin_dir"
done

# visual and editor
export VISUAL="/usr/bin/nvim"
export EDITOR="$VISUAL"
export PAGER="less"

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
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# man
export MANWIDTH=78

# fzf
PATH="$PATH:$HOME/src/fzf/bin"
export FZF_DEFAULT_OPTS="--height=40% --info=inline --border --select-1 --exit-0 --no-mouse"
export FZF_DEFAULT_COMMAND='idfs --hidden --follow --exclude .git --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type directory"
export FZF_CTRL_T_OPTS="--preview='preview {}' --scheme=path"
export FZF_CTRL_R_OPTS="--scheme=history"
export FZF_ALT_C_OPTS="--preview='preview {}' --scheme=path"

__fzf_select__() {
  eval "$FZF_CTRL_T_COMMAND" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) "$@" -m | while read -r item; do
    printf '%q' "$item"
  done
}

__fzfcmd() {
  [[ -n "$TMUX_PANE" ]] && { [[ "${FZF_TMUX:-0}" != 0 ]] || [[ -n "$FZF_TMUX_OPTS" ]]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}

fzf-file-widget() {
  local selected="$(__fzf_select__)"
  [[ -n "$selected" ]] && selected="$selected "
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}

__fzf_cd__() {
  local dir
  dir=$(eval "$FZF_ALT_C_COMMAND" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) "$@" +m) && printf 'cd %q' "$dir"
}

__fzf_history__() {
  local output
  output=$(
    builtin fc -lnr -2147483648 |
      last_hist=$(HISTTIMEFORMAT='' builtin history 1) perl -n -l0 -e 'BEGIN { getc; $/ = "\n\t"; $HISTCMD = $ENV{last_hist} + 1 } s/^[ *]//; print $HISTCMD - $. . "\t$_" if !$seen{$_}++' |
      FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS +m --read0" $(__fzfcmd) --query "$READLINE_LINE"
  ) || return
  READLINE_LINE=${output#*$'\t'}
  if [[ -z "$READLINE_POINT" ]]; then
    echo "$READLINE_LINE"
  else
    READLINE_POINT=0x7fffffff
  fi
}

bind -m emacs-standard '"\er": redraw-current-line'
bind -m emacs-standard -x '"\C-f": fzf-file-widget'
bind -m emacs-standard -x '"\C-r": __fzf_history__'

t() {
  local comm
  comm="$(__fzf_cd__ --query "$*")"
  history -s "$comm"
  eval "$comm"
}

e() {
  local comm file
  file="$(__fzf_select__ --query "$*")"
  if [[ -n "$file" ]]
  then
    comm="$(printf '%s %s' "vim" "$file")"
    history -s "$comm"
    eval "$comm"
  fi
}

s() {
  local comm file
  file="$(FZF_CTRL_T_COMMAND="$FZF_CTRL_T_COMMAND --no-ignore-vcs" __fzf_select__ --query "$*")"
  if [[ -n "$file" ]]
  then
    comm="$(printf 'start %s' "$file")"
    history -s "$comm"
    eval "$comm"
  fi
}


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

# makefile
export CPPFLAGS="-Wall -std=c++17"
export JAVAC="javac"

# make with custom defaults
m() {
    MAKEFILES="$XDG_CONFIG_HOME/make/makefile" make all "$@"
}


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

# use color by default
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

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
