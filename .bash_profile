if [ -f "$HOME/.bashrc" ]
then
    . $HOME/.bashrc
fi

# set pythonrc
export PYTHONSTARTUP="$HOME/.pythonrc"

# make ls prettier
export LS_COLORS="$LS_COLORS:ow=1;34;35:tw=1;34;35"

# python path
export PYTHONPATH="$PYTHONPATH:/home/jamesrayman/.local/lib/python3.6/sitepackages/"

# tools
export VISUAL="vim"
export EDITOR="vim"
export LESS="$LESS -Q"

# maven
export JAVA_HOME="/usr/lib/jvm/java-15-oracle"
export PATH="$PATH:/mnt/c/tools/apache-maven-3.6.3/bin"

# safe paste
bind 'set enable-bracketed-paste on'
