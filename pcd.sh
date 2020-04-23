#!/bin/bash
#
# Apache License 2.0
#
# Author: Jan Mutter (info@jayefem.de), 2017-2019
#
# Modify pcd.config for configuration
#

#MY_DIR=$(dirname $0)
MY_DIR=""
MY_NAME="cd"
if [[ ! "$0" =~ "bash" ]]; then
	# If not called from alias
	MY_DIR=`dirname $0`/
	MY_NAME=$(basename $0)
fi

MY_LIB_DIR="$MY_DIR"

# Load libraries
source ${MY_LIB_DIR}lib_shelltools.sh

function initialize {
	if [[ -n "$PCD_ALREADY_INITIALIZED" ]];then
	# Only one initialization per session. Start new Bash for new configurations
		return
	fi

	# Load configuration
	source ${MY_DIR}pcd.config

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
		cd $projectPath
	else
		echo "No project found"
	fi
}

function usage {
	echo ""
	echo "Usage: ${MY_NAME} [-h | --help] [-l | --list] <projectname>"
	echo ""
	echo " -h | --help     : Prints this help."
	echo " -l | --list     : Prints a list of all available projects."

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
				usageShortlist;;
			*)
				cdSource $1
	   esac
	   shift
	done
}

initialize

parseCommandoLineParameters $@

