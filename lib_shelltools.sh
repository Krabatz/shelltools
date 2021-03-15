#!/bin/bash
#
# Apache License 2.0
#
# Author: Jan Mutter (info@jayefem.de), 2015-2019
#

################################################################
#
# This script contains utility functions which are used by other 
# scripts.
#
################################################################

OS_DEFAULT="DEFAULT"
OS_MAC="Darwin"
OS_CYGWIN="CYGWIN"

# Logging formatting
fmtError=$(tput bold; tput setf 9)
fmtMessage=$(tput bold; tput setf 4)
fmtNormal=$(tput sgr0; tput setf 0)

################ Utils methods ################

function userInteractionExitOnNo {
    while true; do
        read -p "Do you want to continue? [YyNn]" yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) echo "Script aborted."; exit;;
            * ) echo "Please enter [YyNn].";;
        esac
    done
}

function msg {
	msg="${fmtMessage}$1${fmtNormal}"
	echo "${msg}"
	summaryOutput+=("${msg}")
}

function msgError {
	msg="${fmtError}$1${fmtNormal}"
	echo "${msg}"
	summaryOutput+=("${msg}")
}

function msgWarning {
	msg="${fmtError}$1${fmtNormal}"
	echo "${msg}"
	summaryOutput+=("${msg}")
}

# Bash v3 does not support associative arrays
# and we cannot use ksh since all generic scripts are on bash
# Usage: map_put map_name key value
function map_put {
	mapname=$1
	key=$2

	shift
	shift

	value=$*

	#echo "map_put: mapname: ${mapname} - key: ${key} - value: ${value}"

	alias "${mapname}${key}"="${value}"
}

# map_get map_name key
# @return value
#
function map_get
{
	aliaskey=${1}${2}
	aliasvalue=$(alias "${aliaskey}" 2> /dev/null)

	#>&2 echo "map_get: aliaskey: ${aliaskey} - aliasvalue: ${aliasvalue}"

	# MAPGET=$(alias "${aliaskey}" 2> /dev/null | awk -F"'" '{ print $2; }')

	MAPGET=${aliasvalue#*=}

	if [[ $MAPGET = \'* ]]; then
		MAPGET=${MAPGET:1:${#MAPGET}-2}
	fi

	#>&2 echo "map_get: aliaskey: ${aliaskey} - MAPGET: ${MAPGET}"
	
	echo "$MAPGET"
}

# map_keys map_name 
# @return map keys
#
function map_keys
{
    alias -p | grep $1 | cut -d'=' -f1 | awk -F"$1" '{print $2; }'
}

# Returns "true" if the current git branch is dirty.
function git_dirty {
	#[[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]] && echo "true"
	
	# File exists?
  	[[ -f ".git/MERGE_HEAD" ]] && echo "true"
}

function git_current_branch {
  echo `git rev-parse --abbrev-ref HEAD 2> /dev/null`
}

################ Init ################

function initEnv {
	U_NAME=$(uname)
	OS_PLATFORM=$OS_DEFAULT
	if [[ "$U_NAME" == "Darwin" ]]; then
		OS_PLATFORM=$OS_MAC
	elif [[ "$U_NAME" == *"CYGWIN"* ]]; then
		OS_PLATFORM=$OS_CYGWIN
    fi

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
}

initEnv
