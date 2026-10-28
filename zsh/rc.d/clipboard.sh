if [[ "$OSTYPE" == darwin* ]] ; then
    alias cbc=pbcopy
    alias cbp=pbpaste
elif [ -n "$WAYLAND_DISPLAY" ] && has_cmd wl-copy ; then
    alias cbc=wl-copy
    alias cbp=wl-paste
elif [ -n "$DISPLAY" ] && has_cmd xclip ; then
    alias cbc="xclip -i -selection clipboard"
    alias cbp="xclip -o -selection clipboard"
fi


# vim: ft=zsh
