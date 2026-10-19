if [[ "$OSTYPE" == darwin* ]] && [ -z "$HOMEBREW_PREFIX" ] && [ -x /opt/homebrew/bin/brew ] ; then
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi
