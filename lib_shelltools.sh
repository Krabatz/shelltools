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

    #alias "${1}$2"="$3"
	alias "${mapname}$key"="$value"
}

# map_get map_name key
# @return value
#
function map_get
{
    alias "${1}$2" 2> /dev/null | awk -F"'" '{ print $2; }'
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
	OS_PLATFORM=$OS_DEFAULT
	if [ "$(uname)" == "Darwin" ]; then
		OS_PLATFORM=$OS_MAC
	elif [[ "$(uname)" == *"CYGWIN"* ]]; then
		OS_PLATFORM=$OS_CYGWIN
    fi
}

initEnv
