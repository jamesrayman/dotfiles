case $- in *i*) ;; *) return;; esac # If not running interactively, don't do anything

export PATH="$HOME/.local/bin:$PATH"

if command -v tmux &> /dev/null && [[ ! "$TERM" =~ screen ]] && [[ -z "$TMUX" ]]
then
    exec tmux -u new -t main
fi

tput cup 1000 0 # align to bottom

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# defaults
export VISUAL="nvim"
export EDITOR="$VISUAL"
export PAGER="less"

# locale
export LC_ALL="C.UTF-8"
export LANG="en_US.UTF-8"

# shell
set -P
set enable-bracketed-paste on
shopt -s globstar
shopt -s nullglob
shopt -s checkwinsize
shopt -s direxpand

shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=20000
HISTFILESIZE=20000
HISTFILE="$XDG_STATE_HOME/bash/history"
HISTTIMEFORMAT="%F %T     "

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

PS1='\[\e[1;33m\]\$\[\e[0m\] '

stty erase '^?'
stty werase '' # Allow .inputrc to bind ^W
stty -ixon # Disable ^S and ^Q flow control
stty sane

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export GPG_TTY="$(tty)"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
gpgconf --launch gpg-agent

export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
alias python="python3"
alias pip="pip3"
alias -- -m="python -m"

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export PATH="$PATH:$CARGO_HOME/bin"

export LS_COLORS="ow=1;35:tw=1;35:mi=1;91"
alias la='command ls -laGhv --group-directories-first --color=auto'
alias l='command ls -v --group-directories-first --color=auto'
alias ls='ls -lGhv --group-directories-first --color=auto'

# local PATH
for bin_dir in "$HOME"/projects/*/bin/ "$HOME"/projects/misc/*/bin/
do
    PATH="$PATH:$bin_dir"
done

alias vim="$VISUAL"
alias vi="$VISUAL"

# don't include --incsearch in LESS because it is unresponsive on large files
export LESS="-F -i -Q -R -z-4 -j.5 -Ps%f\:%lb of %L (%Pb\%) "
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
alias more="$PAGER"

alias grep='rg'
alias fgrep='rg -F'
alias egrep='rg'
alias rgrep='rg'

export MANWIDTH=78

export AND="$HOME/andromeda"

export DOT="$HOME/dotfiles"

export FZF_DEFAULT_COMMAND="idfs --hidden --follow --exclude .git --exclude '$XDG_STATE_HOME' --exclude '$XDG_CACHE_HOME' --strip-cwd-prefix"
export FZF_DEFAULT_OPTS="--height=40% --info=inline --border --no-mouse"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type directory"
export FZF_CTRL_T_OPTS="--preview='preview {}' --scheme path"
export FZF_CTRL_T_FILE_OPTS="--type file"
export FZF_CTRL_R_OPTS="--scheme=history"
export FZF_ALT_C_OPTS="--preview='preview {}' --scheme path"
export FZF_TMUX=1

__fzf_select__() {
  eval "$FZF_CTRL_T_COMMAND" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) "$@" -m | while read -r item; do
    printf '%q ' "$item"
  done
}

__fzfcmd() {
  [[ -n "$TMUX_PANE" ]] && { [[ "${FZF_TMUX:-0}" != 0 ]] || [[ -n "$FZF_TMUX_OPTS" ]]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}

fzf-file-widget() {
  local selected="$(__fzf_select__)"
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}

__fzf_cd__() {
  local dir
  dir=$(eval "$FZF_ALT_C_COMMAND" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) "$@" +m) && printf 'cd %q%q' "$FZF_ALT_C_BASE_DIR" "$dir"
}

__ancestor_wds__() {
  local dir="$PWD"
  while dir="${dir%/*}"; [[ -n "$dir" ]]; do printf '%s\n' "$dir"; done
  printf '/\n'
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
T() {
    FZF_ALT_C_COMMAND="$FZF_ALT_C_COMMAND --no-ignore" t "$@"
}

e() {
  local comm file
  file="$(FZF_CTRL_T_COMMAND="$FZF_CTRL_T_COMMAND $FZF_CTRL_T_FILE_OPTS" __fzf_select__ --query "$*")"
  if [[ -n "$file" ]]
  then
    comm="vim $file"
    history -s "$comm"
    eval "$comm"
  fi
}
E() {
    FZF_CTRL_T_COMMAND="$FZF_CTRL_T_COMMAND --no-ignore" e "$@"
}

# modified files
m() {
    FZF_CTRL_T_COMMAND="git feature-diff --name-only" \
    FZF_CTRL_T_FILE_OPTS="" \
    e "$@"
}

s() {
  local comm file
  file="$(FZF_CTRL_T_COMMAND="$FZF_CTRL_T_COMMAND --no-ignore" __fzf_select__ --query "$*")"
  if [[ -n "$file" ]]
  then
    comm="start $file"
    history -s "$comm"
    eval "$comm"
  fi
}

u() {
  local comm
  comm="$(FZF_ALT_C_COMMAND="__ancestor_wds__" __fzf_cd__ --query "$*")"
  history -s "$comm"
  eval "$comm"
}


f() {
  local comm file
  file="$(FZF_CTRL_T_COMMAND="$FZF_CTRL_T_COMMAND --type file" __fzf_select__ --query "$*")"
  if [[ -n "$file" ]]
  then
    comm="cd ${file%/*}"
    history -s "$comm"
    eval "$comm"
  fi
}
F() {
    FZF_CTRL_T_COMMAND="$FZF_CTRL_T_COMMAND --no-ignore" f "$@"
}

c() {
  local comm
  comm="$(FZF_ALT_C_COMMAND="printf '%s\n' */" __fzf_cd__ --query "$*")"
  history -s "$comm"
  eval "$comm"
}

C() {
  local comm
  comm="$(FZF_ALT_C_COMMAND="printf '%s\n' */ .?*/ | sed '/^\.\.\/$/d'" __fzf_cd__ --query "$*")"
  history -s "$comm"
  eval "$comm"
}

w() {
    FZF_ALT_C_COMMAND="command ls -1 $HOME/projects" \
    FZF_ALT_C_OPTS="$FZF_ALT_C_OPTS --preview='preview $HOME/projects/{}'" \
    FZF_ALT_C_BASE_DIR="$HOME/projects/" \
    t "$@"
}

export GEM_HOME="$XDG_DATA_HOME/gem"
export PATH="$GEM_HOME/bin:$PATH"

export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"

export NODE_REPL_HISTORY="$XDG_STATE_HOME/node/history"

export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"

export DOT_SAGE="$XDG_CONFIG_HOME/sage"

export ASYMPTOTE_HOME="$XDG_CONFIG_HOME/asy"

export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"

export OPAMROOT="$XDG_DATA_HOME/opam"
[ -r "$OPAMROOT/opam-init/init.sh" ] && source "$OPAMROOT/opam-init/init.sh" &> /dev/null

# makefile
export CXXFLAGS="-Wall -Wpedantic -Wconversion -std=c++20"
export JAVAC="javac"

# "build": make with custom defaults
b() {
    if (( $# > 0 ))
    then
        MAKEFILES="$XDG_CONFIG_HOME/make/makefile" make "$@"
    else
        MAKEFILES="$XDG_CONFIG_HOME/make/makefile" make all
    fi
}

# Quick edit common files
alias eb="vi $HOME/.bashrc"
alias ee="vi $XDG_CONFIG_HOME/bash/extra"
alias eg="vi $XDG_CONFIG_HOME/git/config"
alias ei="vi $XDG_CONFIG_HOME/readline/inputrc"
alias em="vi $XDG_CONFIG_HOME/make/makefile"
alias en="vi $AND/note/card.txt" # notecard
alias eq="vi $AND/note/questions.txt"
alias es="vi $XDG_CONFIG_HOME/bash/secret"
alias et="vi $XDG_CONFIG_HOME/task/taskrc"
alias eu="vi $XDG_CONFIG_HOME/tmux/tmux.conf"
alias ev="vi $XDG_CONFIG_HOME/nvim/init.lua" # .vimrc
alias esp="vi $XDG_CONFIG_HOME/nvim/en.utf-8.add" # spell

alias tmux='tmux -u'

alias mutt="neomutt"

# refresh tmux on cd
cd() {
    command cd "$@"
    tmux refresh-client -S
}

alias -- -='cd ~-'
alias ..='cd ..'

# safety
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

alias vpn='nmcli con up id su'

# aliases to force XDG compliance
alias units='units --history "$XDG_STATE_HOME/units/history"'
alias wget='wget --hsts-file "$XDG_STATE_HOME/wget/hsts"'

# Evaluate args, print them, and add them to history, but don't execute them
v() {
    history -s "$@"
    printf "%s\n" "$*"
}

# git alias
g() {
    if (( $# == 0 ))
    then
        git s
    elif [[ "$*" == "-" ]]
    then
        git checkout -
    else
        git "$@"
    fi
}

__tmux_open__() {
    vim "$1"
}

# TODO
command_not_found_handle () {
    if [ -x /usr/lib/command-not-found ]; then
        /usr/lib/command-not-found -- "$1";
        return $?;
    else
        if [ -x /usr/share/command-not-found/command-not-found ]; then
            /usr/share/command-not-found/command-not-found -- "$1";
            return $?;
        else
            printf "%s: command not found\n" "$1" 1>&2;
            return 127;
        fi;
    fi
}

# any extra machine-dependent configuration
[ -r "$XDG_CONFIG_HOME/bash/extra" ] && source "$XDG_CONFIG_HOME/bash/extra"
[ -r "$XDG_CONFIG_HOME/bash/secret" ] && source "$XDG_CONFIG_HOME/bash/secret"
