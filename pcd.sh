#!/bin/bash
#
# Apache License 2.0
#
# Author: Jan Mutter (info@jayefem.de), 2017-2019
#
# For configuration copy _shelltools to .shelltools and put it to:
# - Your home directory (e.g. ~/.shelltools) or
# - This directory (e.g. /shelltools/.shelltools)
#

#MY_DIR=$(dirname $0)
MY_DIR=""
MY_NAME="cdp"
if [[ ! "$0" =~ "bash" ]]; then
	# If not called from alias
	MY_DIR=`dirname $0`/
	MY_NAME=$(basename $0)
fi

MY_LIB_DIR="$MY_DIR"

# Load libraries
source ${MY_LIB_DIR}lib_shelltools.sh

function setup {
	DRYRUN=""
	CD_DIR=""
}

function loadConfiguration {
	if [[ -f "${MY_DIR}pcd.config" ]]; then
		source ${MY_DIR}pcd.config
	elif [[ -f "${MY_DIR}.shelltools" ]]; then
		source ${MY_DIR}.shelltools
	elif [[ -f "${HOME}/.shelltools" ]]; then
		source "${HOME}/.shelltools"
	fi
}

function initialize {
	if [[ -n "$PCD_ALREADY_INITIALIZED" ]];then
		# Only one initialization per session. Start new Bash for new configurations
		return
	fi

	# Load configuration
	loadConfiguration

	# allexport: Automatically exports all variables and functions that you create or modify after giving this command.
	set -a
		
	cdSourceMap=${MY_NAME}_configMap_

	for line in "${projectConfigArray[@]}" ; do
		key="${line%\#\#\#*}"
		value="${line#*\#\#\#}"

		#echo "map_put $cdSourceMap ${key} ${value}"

	    map_put $cdSourceMap ${key} ${value}
	done

	export PCD_ALREADY_INITIALIZED=true
}

function cdSource {
	project=$1

	if [ -z "$project" ]; then
		return
	fi

	#echo "change dir to $project"

	projectPath=$(map_get $cdSourceMap $project)

	if [ -n "$projectPath" ]; then
		echo "cd $projectPath"

		if [[ "$DRYRUN" == "true" ]];then
			echo ""
			echo "== Dry run. Did not execute command. =="
			return
		fi

		cd $projectPath

		RETURN_CODE=""
	else
		RETURN_CODE="NO_PORJECT_FOUND"

		if [[ -z "$PARAM_NO_WARNING" ]];then
			echo "No project found"
		fi
	fi
}

function usage {
	echo ""
	echo "Usage: ${MY_NAME} [-h | --help] [-l | --list] [ --no-warning ] [ --dryrun ] <projectname>"
	echo ""
	echo " -h | --help     : Prints this help."
	echo " -l | --list     : Prints a list of all available projects."
	echo " --no-warning    : No info or warning is printed out."
	echo " --dryrun        : Dry run. Prints the command without executing it."
	echo ""
	echo "This program changes directory to the configured directory of the given <projectname>."
	echo ""
	echo "For configuration copy _shelltools to .shelltools and put it to:"
	echo " - Your home directory (e.g. ~/.shelltools) or"
	echo " - This directory (e.g. /shelltools/.shelltools)"
	echo ""
	echo "See also https://github.com/jayefem/shelltools"
	echo ""

	#exit 1
}

function usageOperations {
	echo ""
	echo "Usage: ${MY_NAME} <projectname>"
	echo ""
	echo "Print help: ${MY_NAME} -h"
	echo ""
	echo "List of all available projects:"
	echo ""
	keys=$(map_keys $cdSourceMap)
	for key in ${keys[@]}; do
		echo "  $key"
	done

	#exit 1
}

function usageShortlist {
	keys=$(map_keys $cdSourceMap)
	shortlist=" "
	for key in ${keys[@]}; do
		shortlist="${shortlist}${key} "
	done
	echo ${shortlist}

	#exit 1
}

function parseCommandoLineParameters {
	while [ "$1" != "" ]; do
		case $1 in
			-h|--help)
				usage;;
			-l|--list)
				usageOperations;;
			--shortlist)
				PCD_ALREADY_INITIALIZED="";
				COMMAND="usageShortlist";;
			--dryrun)
				DRYRUN=true;;
			--no-warning)
				PARAM_NO_WARNING=true;;
			*)
				CD_DIR=$1;
				COMMAND="cdSource";;
	   esac
	   shift
	done
}

setup

parseCommandoLineParameters $@

initialize

if [[ "$COMMAND" == "usageShortlist" ]];then
	usageShortlist
elif [[ "$COMMAND" == "cdSource" ]];then
	cdSource $CD_DIR
fi