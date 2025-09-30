# My zshrc


autoload -Uz compinit promptinit
#autoload -Uz run-help

compinit
promptinit
# set prompt theme here
# prompt walters

# a portable newline variable
# _newline=$'\n'

# notes on colors:
# The %F{}%f colour should be set to colour, a decimal integer, the name of
# one of the eight most widely-supported colours or as a ‘#’ followed by an RGB
# triplet in hexadecimal format.
# or use plain escape sequence \033[...m

# custom prompt
#PS1='
#%F{blue}%n%F{cyan}@%f%m : %B%F{blue}%(5~!.../!)%4~%f%b : %(1j.%B%F{magenta}%j%f%b : .)%B%*%b
#%B%(?..[%F{red}%?%f] )%b%B%F{160}>%F{166}>%F{172}>%f%b '
# right aligning text in PS1 is hacky.

if [[ -n $SSH_CONNECTION ]]; then
  ps1_ssh_indicator="%F{214} %f"
else
  ps1_ssh_indicator=""
fi

PS1="%B%(?..%F{red}%?%f)%b%K{#444444}%(1j.%B%F{207}J%j%f%b.)%F{195}[%*]%f%n%F{#75b5aa}@%f%m %F{#6a9fb5}%(5~!.../!)%4~%f%k%(!.%F{214}%f.%F{#444444}%f) "

#autoload bashcompinit
#bashcompinit
#source /path/to/your/bash_completion_file

# selectable menu for tab-completions
zstyle ':completion:*' menu select
# if no exact match, try case & hypen insensitive match
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z_-}={A-Za-z-_}'

# use extended glob from zsh
setopt EXTENDED_GLOB

# prompt before exiting with bg jobs running
setopt CHECK_JOBS

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
#setopt APPEND_HISTORY
## for sharing history between zsh processes
setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=10000


## never ever beep ever
setopt NO_BEEP

setopt RM_STAR_SILENT

## do not push dir on cd
unsetopt AUTO_PUSHD

setopt autocd

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# autoload -U colors
#colors

###### KEY BINDINGS ######

# zkbd-compatible aliases
typeset -g -A key
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
#key[Control-Left]="${terminfo[kLFT5]}"
#key[Control-Right]="${terminfo[kRIT5]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# use emacs key bindings. this is the default
bindkey -e

# unlike bash, ctrl-u will delete whole line by default in zsh
bindkey "^U" backward-kill-line

# Page Up/Down context search
bindkey "${key[PageUp]}" history-beginning-search-backward
bindkey "${key[PageDown]}" history-beginning-search-forward

# Up/Down arrow history
bindkey "${key[Up]}" up-line-or-history
bindkey "${key[Down]}" down-line-or-history

# word navigation : ctrl + left/right
bindkey '\033[1;5C' forward-word
bindkey '\033[1;5D' backward-word

# DEL key
bindkey "${key[Delete]}" delete-char

# [Shift-Tab] - move through the completion menu backwards
bindkey "${key[Shift-Tab]}" reverse-menu-complete

# [Space] - do history expansion
# bindkey ' ' magic-space

# Ignore ctrl-S
stty -ixon

if [[ $OSTYPE == darwin* ]]; then
export COLORTERM=1
fi

# Set-up ls colors
if [ -z ${LS_COLORS} ]; then
  test -r ~/.dir_colors && eval "$(dircolors -b ~/.dir_colors)" || eval "$(dircolors -b)"
fi

##### alias
(( ${+aliases[ls]} )) || alias ls="ls --color=auto"
alias l="ls -Alh"
alias d="dirs -v"
alias ...="cd ../.."

# Remove `which' alias
(( ${+aliases[which]} )) && unalias which

##### Functions
mkcd() {
  if [ $# -eq 0 ]; then
    echo "Usage: mkcd <directory>"
    return 1
  fi
  mkdir -p -- "$1" && cd -- "$1"
}

# Rustup. Activate only if there isn't another active rust installation.
if (( ! $+commands[cargo] )) && [ -r ${HOME}/.cargo/env ]; then
  source ${HOME}/.cargo/env
fi


# plugin dir
_zsh_plugin_dir="${HOME}/.zsh_plugins"

# syntax highlighting
_zsh_syntax_hl_path="${_zsh_plugin_dir}/\
fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

if [ -r "${_zsh_syntax_hl_path}" ]
then
  source "${_zsh_syntax_hl_path}"
fi

# auto suggestions
_zsh_autosuggestions_path="${_zsh_plugin_dir}/\
zsh-autosuggestions/zsh-autosuggestions.zsh"

[ -r "${_zsh_autosuggestions_path}" ] && source "${_zsh_autosuggestions_path}"

##### Site-specific config #####
if [ -d ~/.zshrc.d ]; then
    for rc in ~/.zshrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
