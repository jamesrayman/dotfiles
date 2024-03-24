# If not running interactively, don't do anything
case $- in *i*) ;; *) return;; esac

if command -v tmux &> /dev/null && [[ ! "$TERM" =~ screen ]] && [[ -z "$TMUX" ]]
then
    exec tmux -u
fi

# XDG
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

# history
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=20000
HISTFILESIZE=20000
HISTFILE="$XDG_STATE_HOME/bash/history"
HISTTIMEFORMAT="%F %T     "

# completion
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

# prompt
[ -r '/usr/share/git/completion/git-prompt.sh' ] && source '/usr/share/git/completion/git-prompt.sh'
GIT_PS1_SHOWDIRTYSTATE=y
GIT_PS1_SHOWUNTRACKEDFILES=y
GIT_PS1_SHOWUPSTREAM=auto
PS1=''
GIT_PS1_SHOWCOLORHINTS=y
PROMPT_COMMAND='__git_ps1 "\[\e[0;36m\][\t]\[\e[0m\] \[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]" "\$ "'

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# stty
stty erase '^?'
stty werase '' # Allow .inputrc to bind ^W
stty -ixon # Disable ^S and ^Q flow control
stty sane

# inputrc
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

# GCC
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# GPG
export GPG_TTY="$(tty)"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
gpgconf --launch gpg-agent

# Python
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
alias python="python3"
alias pip="pip3"
alias -- -m="python -m"

# Rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export PATH="$PATH:$CARGO_HOME/bin"

# ls
export LS_COLORS="ow=1;35:tw=1;35:mi=1;91"
alias la='command ls -laGhv --group-directories-first --color=auto'
alias l='command ls -v --group-directories-first --color=auto'
alias ls='ls -lGhv --group-directories-first --color=auto'

# local PATH
export PATH="$HOME/.local/bin:$PATH"
for bin_dir in "$HOME"/Projects/*/bin/ "$HOME"/Projects/misc/*/bin/
do
    PATH="$PATH:$bin_dir"
done

# Use $VISUAL for vi-inspired editors
alias vim="$VISUAL"
alias vi="$VISUAL"

# less
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

# Favor rg over grep
alias grep='rg'
alias fgrep='rg -F'
alias egrep='rg'
alias rgrep='rg'

# man
export MANWIDTH=78

# Andromeda
export AND="$HOME/andromeda"

# Dotfiles
export DOT="$HOME/dotfiles"

# fzf
export FZF_DEFAULT_COMMAND="idfs --hidden --follow --exclude .git --exclude '$XDG_STATE_HOME' --exclude '$XDG_CACHE_HOME' --strip-cwd-prefix"
export FZF_DEFAULT_OPTS="--height=40% --info=inline --border --no-mouse"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type directory"
export FZF_CTRL_T_OPTS="--preview='preview {}' --scheme path"
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
T() {
    FZF_ALT_C_COMMAND="$FZF_ALT_C_COMMAND --no-ignore" t "$@"
}

e() {
  local comm file
  file="$(FZF_CTRL_T_COMMAND="$FZF_CTRL_T_COMMAND --type file" __fzf_select__ --query "$*")"
  if [[ -n "$file" ]]
  then
    comm="$(printf 'vim %s' "$file")"
    history -s "$comm"
    eval "$comm"
  fi
}
E() {
    FZF_CTRL_T_COMMAND="$FZF_CTRL_T_COMMAND --no-ignore" e "$@"
}

s() {
  local comm file
  file="$(FZF_CTRL_T_COMMAND="$FZF_CTRL_T_COMMAND --no-ignore" __fzf_select__ --query "$*")"
  if [[ -n "$file" ]]
  then
    comm="$(printf 'start %s' "$file")"
    history -s "$comm"
    eval "$comm"
  fi
}

# TODO use fzf to select a job
alias j=jobs
# f is find and cd
alias f=t


# Ruby
export GEM_HOME="$XDG_DATA_HOME/gem"
export PATH="$GEM_HOME/bin:$PATH"

export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"

# Node
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node/history"

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
[ -r "$OPAMROOT/opam-init/init.sh" ] && source "$OPAMROOT/opam-init/init.sh" &> /dev/null

# makefile
export CPPFLAGS="-Wall -std=c++17"
export JAVAC="javac"

# make with custom defaults
m() {
    if (( $# > 0 ))
    then
        MAKEFILES="$XDG_CONFIG_HOME/make/makefile" make "$@"
    else
        MAKEFILES="$XDG_CONFIG_HOME/make/makefile" make all
    fi
}
mc() {
  m clean "$@"
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

# tmux
alias tmux='tmux -u'

# Mutt
alias mutt="neomutt"

# consistent with autocd
alias -- -='cd -'
alias ..='cd ..'

# safety
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# better diff
alias diff='delta'

# weather
alias weather='curl -sSL https://wttr.in | head -n -2'

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

# any extra machine-dependent configuration
[ -r "$XDG_CONFIG_HOME/bash/extra" ] && source "$XDG_CONFIG_HOME/bash/extra"
[ -r "$XDG_CONFIG_HOME/bash/secret" ] && source "$XDG_CONFIG_HOME/bash/secret"
