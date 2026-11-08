# should come after adding all custom fpaths

autoload -Uz compinit
if ! (( ${+_comps} )) ; then
  compinit
fi
