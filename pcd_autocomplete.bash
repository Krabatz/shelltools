#!/bin/bash
#
# Apache License 2.0
#
# Author: Jan Mutter (info@jayefem.de), 2017-2019
#

################################################################
#
# Autocompletion for pcd.sh
#
# Setup (e.g in your .bash_profile or .bashrc):
# source <path_to>/pcd_autocomplete.bash
#
# Prequisites:
# 1. pcd.sh etc. must be already added to PATH environment variable.
# 2. Added aliases:
#    alias cdp='source pcd.sh'
#    alias run='source prun.sh'
#    alias build='source pbuild.sh'
#    alias stop='source pstop.sh'
#
################################################################

_script()
{
  _script_commands=$(pcd.sh --shortlist)

  local cur prev
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "${_script_commands}" -- ${cur}) )

  return 0
}

complete -o default -o nospace -F _script pcd.sh
complete -o default -o nospace -F _script pcd
complete -o default -o nospace -F _script cdp
complete -o default -o nospace -F _script cds
complete -o default -o nospace -F _script prun.sh
complete -o default -o nospace -F _script run
complete -o default -o nospace -F _script pstop.sh
complete -o default -o nospace -F _script stop
complete -o default -o nospace -F _script pbuild.sh
complete -o default -o nospace -F _script build