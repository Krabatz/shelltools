#!/bin/bash
#
# Apache License 2.0
#
# Author: Jan Mutter (info@jayefem.de), 2017-2019
#
# Modify pcd.config for configuration
#

MY_DIR=""
MY_EXEC_NAME="run"
if [[ ! "$0" =~ "bash" ]]; then
	# If not called from alias
	MY_DIR=`dirname $0`/
fi

source ${MY_DIR}pexecute.sh