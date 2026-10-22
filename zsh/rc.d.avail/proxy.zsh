proxy_set() {
    if [ $# -eq 0 ]; then
        _my_proxy=${my_proxy:-http://127.0.0.1:1080}
    else
        _my_proxy=$1
    fi

    if ! [[ "$_my_proxy" =~ ^[[:alnum:]]+://.+:[0-9]+$ ]] ; then
        echo >&2 "Invalid proxy address: $_my_proxy"
        return 2
    fi

    export all_proxy="$_my_proxy" http_proxy="$_my_proxy" https_proxy="$_my_proxy"
    # Print a message if in an interactive prompt
    (( $zsh_eval_context[(Ie)toplevel] )) && echo "Proxy set to $_my_proxy"
    unset _my_proxy
}

proxy_setp() {
    if [ $# -eq 0 ] || [[ ! "$1" =~ ^[0-9]+$ ]]; then
        echo >&2 "Usage: $0 <PORT>"
        return 2
    fi

    proxy_set "${all_proxy%:*}:$1"
}

proxy_unset() {
    unset all_proxy
    unset http_proxy
    unset https_proxy
    unset ALL_PROXY
    unset HTTP_PROXY
    unset HTTPS_PROXY
    echo "Proxy variables unset."
}

proxy_set


# vim: ft=zsh
