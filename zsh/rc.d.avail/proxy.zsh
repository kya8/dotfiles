typeset -gr _default_proxy="http://127.0.0.1:1080"

proxy_set() {
    local _my_proxy
    if [ $# -eq 0 ]; then
        _my_proxy=${my_proxy:-${_default_proxy:?}}
    elif [[ "$1" =~ ^[[:alnum:]]+://.+:[0-9]+$ ]] ; then
        _my_proxy=$1
    elif [[ "$1" =~ ^[0-9]+$ ]] ; then # A port number
        [ -z "$all_proxy" ] && all_proxy=${_default_proxy:?}
        _my_proxy="${all_proxy%:*}:$1"
    else
        echo >&2 "Invalid proxy address or port: $1"
        return 2
    fi

    export all_proxy="$_my_proxy" http_proxy="$_my_proxy" https_proxy="$_my_proxy"
    is_tin && echo "Proxy set to $_my_proxy"
}

proxy_unset() {
    unset all_proxy
    unset http_proxy
    unset https_proxy
    unset ALL_PROXY
    unset HTTP_PROXY
    unset HTTPS_PROXY
    is_tin && echo "Proxy variables unset."
}

proxy_run() {
    if [ $# -lt 2 ]; then
        echo >&2 "Usage: $0 <PROXY|PORT|-u> <COMMAND> [ARG...]"
        return 2
    fi

    local _my_proxy
    if [[ "$1" = -u ]]; then
        _my_proxy=u # No proxy
    elif [[ "$1" =~ ^[[:alnum:]]+://.+:[0-9]+$ ]] ; then
        _my_proxy=$1
    elif [[ "$1" =~ ^[0-9]+$ ]] ; then # A port number
        [ -z "$all_proxy" ] && all_proxy=${_default_proxy:?}
        _my_proxy="${all_proxy%:*}:$1"
    else
        echo >&2 "Invalid proxy address or port: $1"
        return 2
    fi
    shift

    if [[ "$_my_proxy" = u ]]; then
        =env -u all_proxy\
             -u http_proxy\
             -u https_proxy\
             -u ALL_PROXY\
             -u HTTP_PROXY\
             -u HTTPS_PROXY\
            "$@"
    else
        # is_tin && echo "Using proxy $_my_proxy"
        =env "all_proxy=${_my_proxy}"\
            "http_proxy=${_my_proxy}"\
            "https_proxy=${_my_proxy}"\
            "$@"
    fi
}

proxy_print() {
    local var
    for var in all_proxy http_proxy https_proxy ALL_PROXY HTTP_PROXY HTTPS_PROXY
    do
        if is_exported "$var" ; then
            print -P "%B%F{cyan}${var}%f%b=${(P)var}"
        elif [ $? -eq 1 ] ; then
            print -P "%B%F{202}(Not exported)%f%b %F{cyan}${var}%f=${(P)var}"
        else
            print -P "%B%F{245}${var}%f%b is not set."
        fi
    done
}

[ -z "$all_proxy" ] && proxy_set ||:


# vim: ft=zsh
