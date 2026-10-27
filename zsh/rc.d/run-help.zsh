unalias run-help &>/dev/null ||:
autoload -Uz run-help run-help-git
HELPDIR="/usr/share/zsh/${ZSH_VERSION}/help"
alias help=run-help
