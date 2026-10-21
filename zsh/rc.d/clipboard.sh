if [[ "$OSTYPE" == darwin* ]] ; then
    alias c=pbcopy
    alias p=pbpaste
elif [ -n "$WAYLAND_DISPLAY" ] && has_cmd wl-copy ; then
    alias c=wl-copy
    alias p=wl-paste
elif [ -n "$DISPLAY" ] && has_cmd xclip ; then
    alias c="xclip -i -selection clipboard"
    alias p="xclip -o -selection clipboard"
fi


# vim: ft=zsh
