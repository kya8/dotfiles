# Common functions, definitions that might be used by subsequent scripts

cmd_exists() {
    command -v "$1" >/dev/null 2>&1
}

zmodload -F zsh/stat b:zstat
