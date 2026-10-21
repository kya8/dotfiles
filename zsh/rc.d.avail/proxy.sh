proxy_set() {
    if [ $# -eq 0 ]; then
        _my_proxy=${my_proxy:-http://127.0.0.1:1080}
    else
        _my_proxy=$1
    fi
    export all_proxy="$_my_proxy" http_proxy="$_my_proxy" https_proxy="$_my_proxy"
    unset _my_proxy
}

proxy_unset() {
    unset all_proxy
    unset http_proxy
    unset https_proxy
    unset ALL_PROXY
    unset HTTP_PROXY
    unset HTTPS_PROXY
}

proxy_set
