#!/bin/bash
#
# Apache License 2.0
#
# Author: Jan Mutter (info@jayefem.de), 2017-2019
#
# Modify pcd.config for configuration
#
# Script is not standalone but called by build.sh and run.sh
# The following variables should be already set from calling script:
# 	- MY_DIR
# 	- MY_EXEC_NAME (values: run | stop | build)
#

MY_LIB_DIR="$MY_DIR"

# Load libraries
source ${MY_LIB_DIR}lib_shelltools.sh

function initialize {
	# Load configuration
	source ${MY_DIR}pcd.config

	# allexport: Automatically exports all variables and functions that you create or modify after giving this command.
	set -a
		
	configMap=${MY_EXEC_NAME}_configMap_

	if [[ "${MY_EXEC_NAME}" == "run" ]];then
		for line in "${runConfigArray[@]}" ; do
			key="${line%\#\#\#*}"
			value="${line#*\#\#\#}"

			#echo "run - configMap: $configMap - key: ${key} - value: ${value}"

			map_put $configMap ${key} ${value}
		done
	elif [[ "${MY_EXEC_NAME}" == "stop" ]];then
		for line in "${stopConfigArray[@]}" ; do
			key="${line%\#\#\#*}"
			value="${line#*\#\#\#}"

			#echo "run - configMap: $configMap - key: ${key} - value: ${value}"

			map_put $configMap ${key} ${value}
		done
	else
		for line in "${buildConfigArray[@]}" ; do
			key="${line%\#\#\#*}"
			value="${line#*\#\#\#}"

			#echo "build - configMap: $configMap - key: ${key} - value: ${value}"

			map_put $configMap ${key} ${value}
		done
	fi
}

function changeToApplicationDir {
	if [ -n "$1" ]; then
		source $MY_DIR"pcd.sh" $1
	fi

	APPLICATION_DIR="$(basename `pwd`)"
}

function runCommand {
	runCmd=$*

	echo "${runCmd}"
	eval ${runCmd}
}

function buildDefault {
	#echo "buildDefault"

	if [[ -f "pom.xml" ]];then
		runCommand "mvn clean install"
	elif [[ -f "build.gradle" ]];then
		runCommand "./gradlew compileJava"
	elif [[ -f "package.json" ]];then
		#echo "npm pack"
		#source npm pack
		runCommand "npm pack"
	else
		echo "No project found"
	fi
}

function runDefault {
	#echo "runDefault"

	if [[ -f "pom.xml" ]];then
		runCommand "mvn spring-boot:run"
	elif [[ -f "build.gradle" ]];then
		runCommand "./gradlew bootRun"
	elif [[ -f "Vagrantfile" ]];then
		runCommand "vagrant up"
	elif [[ -f "package.json" ]];then
		runCommand "npm start"
	else
		echo "No project found"
	fi
}

function stopDefault {
	#echo "stopDefault"

	if [[ -f "pom.xml" ]];then
		runCommand "mvn spring-boot:stop"
	elif [[ -f "Vagrantfile" ]];then
		runCommand "vagrant halt"
	elif [[ -f "package.json" ]];then
		runCommand "npm stop"
	else
		echo "No project found"
	fi
}

function execApplication {
	if [ -z "$APPLICATION_DIR" ]; then
		return
	fi

	projectCmd=$(map_get $configMap $APPLICATION_DIR)

	#echo "MY_EXEC_NAME: ${MY_EXEC_NAME} - projectCmd: $projectCmd - configMap: $configMap"

	if [ -n "$projectCmd" ]; then
		runCommand $projectCmd
	else
		if [[ "${MY_EXEC_NAME}" == "run" ]];then
			runDefault
		elif [[ "${MY_EXEC_NAME}" == "stop" ]];then
			stopDefault
		else
			buildDefault
		fi
	fi
}

function usage {
	echo ""
	echo "Usage: ${MY_EXEC_NAME} [-h | --help] <projectname>"
	echo ""
	echo " -h | --help     : Prints this help."
	echo ""
	echo "This program ${MY_EXEC_NAME} executes a certain command according to the given <projectname>. configuration in pcd.config"

	NO_RUN="true"
}

function parseCommandoLineParameters {
	while [ "$1" != "" ]; do
		case $1 in
			-h|--help)
				usage;;
			*)
        		;;
	   esac

	   shift
	done
}

parseCommandoLineParameters $@

if [[ -z "${NO_RUN}" ]]; then
	initialize

	changeToApplicationDir "$1"

	execApplication
fi

