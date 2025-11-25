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

dotfiles=${dotfiles:-~/.dotfiles}

if [ ! -e "${HOME}/.zsh" ]; then
ln -s "${dotfiles}/zsh" "${HOME}/.zsh" ||:
fi
ln -s ".zsh/zshrc" "${HOME}/.zshrc" ||:
ln -s "${dotfiles}/vimrc" "${HOME}/.vimrc" ||:

config_dir=${XDG_CONFIG_HOME:-${HOME}/.config}

# tmux
# https://github.com/tmux/tmux/issues/142
tmux_dir=${config_dir}/tmux
mkdir -p "${tmux_dir}"
ln -s "${dotfiles}/tmux.conf" "${tmux_dir}/tmux.conf" ||:

# git
git_dir=${config_dir}/git
mkdir -p "${git_dir}"
ln -s "${dotfiles}/git/config.${os_type}" "${git_dir}/config" ||:

# mpv
mpv_dir=${config_dir}/mpv
mkdir -p "${mpv_dir}"
ln -s "${dotfiles}/mpv/mpv.conf.${os_type}" "${mpv_dir}/mpv.conf" ||:
ln -s "${dotfiles}/mpv/input.conf" "${mpv_dir}/input.conf" ||:
