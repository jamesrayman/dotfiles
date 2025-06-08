if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ] ; then
    exec sway
fi

if [ -f "$HOME/.bashrc" ]
then
    source "$HOME/.bashrc"
fi
