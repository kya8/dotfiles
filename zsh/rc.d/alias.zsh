if ! has_cmd 7z && has_cmd 7zz ; then
    alias 7z=7zz
fi

has_cmd sudo && alias sudo="sudo "

if has_cmd git ; then
    alias g=git
fi

if [[ ${OSTYPE} == linux* ]] && has_cmd systemctl ; then
  alias sc=systemctl
  alias scu="systemctl --user"
fi

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

has_cmd container && alias ct=container


# ----------------------------------------------------------

alias md="mkdir -p"
alias mv="mv -i"
