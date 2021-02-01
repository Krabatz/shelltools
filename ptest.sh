#!/bin/bash
#
# Apache License 2.0
#
# Author: Jan Mutter (info@jayefem.de), 2017-2019
#
# Modify pcd.config for configuration
#

if test -n "$ZSH_VERSION"; then
  PROFILE_SHELL=zsh
elif test -n "$BASH_VERSION"; then
  PROFILE_SHELL=bash
elif test -n "$KSH_VERSION"; then
  PROFILE_SHELL=ksh
elif test -n "$FCEDIT"; then
  PROFILE_SHELL=ksh
elif test -n "$PS3"; then
  PROFILE_SHELL=unknown
else
  PROFILE_SHELL=sh
fi

MY_DIR=""
MY_EXEC_NAME="test"

if [[ "$PROFILE_SHELL" == "zsh" ]]; then
	MY_PATH=$(where pcd.sh)
	MY_DIR=`dirname $MY_PATH`/
elif [[ "$PROFILE_SHELL" == "bash" ]]; then
	if [[ ! "$0" =~ "bash" ]]; then
		# If not called from alias
		MY_DIR=`dirname $0`/
	fi
fi

source ${MY_DIR}pexecute.sh