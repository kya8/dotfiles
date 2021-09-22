# taocris's zshrc


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

PS1='%B%(?..%F{red}%?%f)%b[%*]%m %F{blue}%(5~!.../!)%4~%f$ '

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

HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=5000


## never ever beep ever
setopt NO_BEEP

## do not push dir on cd
unsetopt AUTO_PUSHD

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# autoload -U colors
#colors

###### KEY BINDINGS ######

# use emacs key bindings. this is the default
bindkey -e

# use terminfo keycodes... or not.

# Notes: octal ANSI \033 should work for all platforms.
# \e or \x1b or ^[ might not work on some platforms. \e doesn't work in macOS.

# "\e[" is a CSI(Control Sequence Indicator)
# https://en.wikipedia.org/wiki/ANSI_escape_code

# unlike bash, ctrl-u will delete whole line by default in zsh
bindkey "^U" backward-kill-line

# Page Up/Down context search
bindkey "\e[5~" history-beginning-search-backward
bindkey "\e[6~" history-beginning-search-forward

# Up/Down arrow history
bindkey "\e[A" up-line-or-history
bindkey "\e[B" down-line-or-history

# word navigation : ctrl + left/right
bindkey '\e[1;5C' forward-word
bindkey '\e[1;5D' backward-word 

# DEL key
bindkey "\e[3~" delete-char

# [Shift-Tab] - move through the completion menu backwards
# bindkey "${terminfo[kcbt]}" reverse-menu-complete

# [Space] - do history expansion
# bindkey ' ' magic-space

# TODO: Add Linux Console keys. man 4 console_codes


##### alias
(( ${+aliases[ls]} )) || alias ls="ls --color=auto"
alias l="ls -Alh"
alias d="dirs -v"
alias ..="cd .."
alias ...="cd ../.."

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
_zshrc_local_config="${HOME}/.zshrc_local"
[ -r "${_zshrc_local_config}" ] && source "${_zshrc_local_config}" || :
