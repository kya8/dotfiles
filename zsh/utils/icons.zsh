# Nerd symbols

typeset -A ps_icons ps_colors
ps_icons[fedora]=''; ps_colors[fedora]="#51a2da"
ps_icons[opensuse]=''; ps_colors[opensuse]="#73ba25"
ps_icons[alpine]=''; ps_colors[alpine]="#0d597f"
ps_icons[gentoo]=''
ps_icons[ubuntu]=''; ps_colors[ubuntu]="#e95420"
ps_icons[debian]=''
ps_icons[arch]=''
ps_icons[rocky]=''
ps_icons[rhel]=''
ps_icons[tux]=''

ps_icons[macos]=''; ps_colors[macos]="#ffffff"
ps_icons[freebsd]=''
ps_icons[openbsd]=''

ps_icons[desktop]='' # Generic icon

ps_icons[left_hard_divider]=''
ps_icons[left_soft_divider]=''
ps_icons[vertical_divider]='│' # unicode box-drawing char
ps_icons[left_half_box]='▌'
ps_icons[right_half_box]='▐'

ps_icons[folder]=''
ps_icons[home]=''

ps_icons[git_branch]=''
ps_icons[git]=''

# For icons that takes up 1.5 cell horizontally
make_icon_box() { # output variable name, icon glyph, box bg, [icon fg]
  if (( $# < 3 )); then
    return 2
  fi
  local out_var=$1
  shift
  typeset -g "${out_var}=%F{$2}▐%K{$2}%f${3:+%F{$3}}${1} ${3:+%f}"
}
