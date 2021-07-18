if [ -f "$HOME/.bashrc" ]
then
    . "$HOME/.bashrc"
fi

# set pythonrc
export PYTHONSTARTUP="$HOME/.pythonrc"

# python path
export PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.6/sitepackages/"

# make ls prettier
export LS_COLORS="$LS_COLORS:ow=1;34;35:tw=1;34;35"

# misc path
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# cd path
export CDPATH="$HOME/symlinks"

# history time stamp
export HISTTIMEFORMAT="%F %T     "

# visual and editor
export VISUAL="/usr/bin/nvim"
export EDITOR="$VISUAL"

# less
export PAGER="less"
export LESS="-F -i -J -W -Q -R -x4 -z-4"
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"

if (( $(less --version | head -n 1 | tr -dc '0-9') < 530 ))
then
    export LESS="$LESS -X"
fi

# man
export MANWIDTH=78

# Use $VISUAL for vi-inspired editors
alias nvim="$VISUAL"
alias vim="$VISUAL"
alias vi="$VISUAL"
alias ex="$VISUAL -e"
alias view="$VISUAL -R"
alias rvim="$VISUAL -Z"
alias rview="$VISUAL -R -Z"

# maven
export JAVA_HOME="/usr/lib/jvm/java-15-oracle"
export PATH="$PATH:/mnt/c/tools/apache-maven-3.6.3/bin"

# shell options

# evaluate symlinks immediately
set -P

set enable-bracketed-paste on


if [ -f "$HOME/.bash_extra" ]
then
    . "$HOME/.bash_extra"
fi
