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
        return 1
        ;;
esac

echo "OS type: ${os_type}"

dotfiles=$(git -C "$(dirname -- "$0")" rev-parse --show-toplevel)
echo "Using dotfiles repo: ${dotfiles}"

my_link() {
    if [ -e "$2" ]; then
        echo "$2 already exists. Skipping."
        return 0
    else
        ln -s "$1" "$2"
    fi
}

supported_os="linux macos freebsd"

link_dir() {
    for src in "$1"/*; do
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

if [ ! -e "${HOME}/.zsh" ]; then
ln -s "${dotfiles}/zsh" "${HOME}/.zsh" ||:
fi
ln -s ".zsh/zshrc" "${HOME}/.zshrc" ||:
ln -s "${dotfiles}/vimrc" "${HOME}/.vimrc" ||:

config_dir=${XDG_CONFIG_HOME:-${HOME}/.config}
mkdir -p "$config_dir"

link_dir "${dotfiles}/xdg/config" "$config_dir"

echo "Setup done."
