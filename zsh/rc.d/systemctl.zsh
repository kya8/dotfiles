if [[ ${OSTYPE} == linux* ]] && has_cmd systemctl ; then
  alias sc=systemctl
  alias scu="systemctl --user"
fi
