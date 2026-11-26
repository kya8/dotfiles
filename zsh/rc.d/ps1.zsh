# --- Prompt config

ps_shorten_pwd() {
  local p=${(%):-%~}
  local -a d=("${(@s[/])${p#/}}")
  d[2,-2]=("${(@M)d[2,-2]##(.|)?}")
  psvar[1]="${(M)p#/}${(j[/])d}"
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd ps_shorten_pwd
ps_shorten_pwd

_ps_color_dir="#87cfff"
_ps_color_sep="#949494"
# _ps_color_dir="#02afff" # default in p10k
_ps_color_host_bg="#000000"
_ps_color_user_bg="#303030"
_ps_color_bg="#444444"

ps1_set() {
local _ps_color_host_bg=${ps_colors[${os_id}_bg]:-${_ps_color_host_bg}}
local _ps_icon_os=${ps_icons[$os_id]:-""}
local _ps_color_os_fg=$ps_colors[$os_id]
local icon
[[ -z $_ps_color_os_fg ]] && icon=${_ps_icon_os}\
|| icon="%F{$_ps_color_os_fg}${_ps_icon_os}%f"

PS1=\
"%B%(?..%F{red}%?%f)%b\
%K{$_ps_color_host_bg}${icon} ${_ps_hostname-%m}\
%F{$_ps_color_host_bg}%K{$_ps_color_user_bg}%f\
${_ps_show_shlvl:+%(2L.%B%F{202\}L%L%f%b.)}\
%(1j.%B%F{207}J%j%f%b.)\
%n%F{$_ps_color_user_bg}%K{$_ps_color_bg}\
%F{$_ps_color_dir}%1v%k\
%(!.%F{214}%f.%F{$_ps_color_bg}%f) "
}
ps1_set
