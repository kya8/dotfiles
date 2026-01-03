#!/bin/sh

set -eu

os_type=$(uname -s)

case "${os_type}" in
    Linux*)
        os_type=linux
        ;;
    Darwin*)
        os_type=macos
        ;;
    FreeBSD)
        os_type=freebsd
        ;;
#     CYGWIN_NT*)
#         os_type=cygwin
#         ;;
#     MINGW*)
#         os_type=mingw
#         ;;
    *)
        echo "Unknown OS"
        exit 1
        ;;
esac

echo "--- OS type: ${os_type}"

dotfiles=$(git -C "$(dirname -- "$0")" rev-parse --show-toplevel)
echo "--- Using dotfiles repo: ${dotfiles}"

my_link() {
    if [ -e "$2" ]; then
        echo "$2 already exists. Skipping."
        return 0
    else
        echo "Linking $2 -> $1"
        ln -sf "$1" "$2" # -e returns false for dangling symlinks, overwrite them with -f
    fi
}

supported_os="linux macos freebsd"

link_dir() {
    for src in "$1"/*; do
        [ -e "$src" ] || continue # Prevent unexpanded *
        pkg="${src##*/}"
        skip=0
        for os in ${supported_os}; do
            pkg_name="${pkg%.${os}}"
            if [ "$pkg_name" != "$pkg" ] ; then
                if [ "$os" != "$os_type" ]; then
                    echo "Skipping ${pkg}"
                    skip=1
                fi
                break;
            fi
        done
        [ ${skip} = 1 ] && continue
        my_link "$src" "$2/$pkg_name"
    done
}

my_link "${dotfiles}/zsh" "${HOME}/.zsh"
my_link ".zsh/zshrc" "${HOME}/.zshrc"
my_link "${dotfiles}/vimrc" "${HOME}/.vimrc"

config_dir=${XDG_CONFIG_HOME:-${HOME}/.config}
mkdir -p "$config_dir"
config_src=${dotfiles}/dirs/config
[ -d "${config_src}" ] && link_dir "$config_src" "$config_dir"


echo "--- Setup done!"
