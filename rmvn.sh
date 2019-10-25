#!/bin/bash
#
# Apache License 2.0
#
# Author: Jan Mutter (info@jayefem.de), 2017-2019
#

MY_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
ONELINE="--------------------------------------------------------------------------------"

function help {
	echo "This script executes the given Maven command in all subdirectories which are Maven modules. The order is given by name and not Maven dependencies!"
	echo ""
	echo "Usage: ${MY_NAME} \"<maven parameters>\""
	echo ""
	echo "Example: ${MY_NAME} validate"

 	exit
}

if [ -z "$1" ]; then
	help
fi

for i in */
do
	if [ ! -f $i/pom.xml ]
	then
		continue
	fi

	echo $ONELINE
	cd $i
	echo $i
	CMD="mvn $@"
	echo "Run ... $CMD"
	$CMD
	cd ..
done