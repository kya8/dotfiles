# Common login environment
# Sourced by a login shell (bash, zsh)

if [ -z "$_my_profile_sourced" ]; then

# homebrew
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi

# User-local PATH
if ! [[ "$PATH" =~ "$HOME/bin:$HOME/.local/bin:" ]]; then
    PATH="$HOME/bin:$HOME/.local/bin:$PATH"
fi
export PATH

# less
export LESS="-i -R"

if command -v nvim &> /dev/null ; then
    export VISUAL=nvim
else
    export VISUAL=vim
fi
export EDITOR=$VISUAL

# Linux-specifics
if [[ "$OSTYPE" == linux* ]]; then
    export WINEDLLOVERRIDES=winemenubuilder.exe=d
fi

_my_profile_sourced=1
fi


# vim: ft=bash
