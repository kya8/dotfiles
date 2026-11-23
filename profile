# Common login environment
# Sourced by a login shell (bash, zsh)

# Only bash & zsh are supported.
if ( [ -n "$ZSH_VERSION" ] && [[ -o login ]] ) ||
   ( [ -n "$BASH_VERSION" ] && shopt -q login_shell ) ; then

# User-local PATH
if ! [[ "$PATH" =~ "$HOME/bin:$HOME/.local/bin:" ]]; then
    PATH="$HOME/bin:$HOME/.local/bin:$PATH"
fi
export PATH

# less
export LESS="-i -R -j 4"

export PAGER=less

if command -v nvim &> /dev/null ; then
    export VISUAL=nvim
else
    export VISUAL=vim
fi
export EDITOR=$VISUAL

export MAIL="${HOME}/.maildir"
export MBOX=$MAIL

# Linux-specifics
if [[ "$OSTYPE" == linux* ]]; then
    export WINEDLLOVERRIDES=winemenubuilder.exe=d
fi

# Use C locale for sorting and datetime
export LC_TIME=C.UTF-8
export LC_COLLATE=C.UTF-8

else
    echo "Warning: I'm being sourced by a non-login or unsupported shell. Skipping." >&2
fi


# vim: ft=bash
