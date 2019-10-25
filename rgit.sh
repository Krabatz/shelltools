#!/bin/bash
#
# Apache Commons License
#
# Author: Jan Mutter, 2017
#


MY_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
ONELINE="--------------------------------------------------------------------------------"

function help {
	echo "This script executes the given git command in all subdirectories which are git repositories."
	echo ""
	echo "Usage: ${MY_NAME} \"<git parameters>\""
	echo ""
	echo "Example: ${MY_NAME} status"

 	exit
}

if [ -z "$1" ]; then
	help
fi

for i in */
do
	if [ ! -d $i/.git ]
	then
		continue
	fi

	echo $ONELINE
	cd $i
	echo $i
	CMD="git $@"
	echo "Run ... $CMD"
	$CMD
	cd ..
done