#!/bin/bash

echo "Finding Git modified files with Windows CRLF endings ..."
echo
echo "This script is not working in Windows Git Bash! Tested on Windows wsl Ubuntu Bash only."
echo

gitCrlfFiles=$(git --no-pager grep -Il $'\r')
gitDirtyFiles=$(git status -s | awk '{if ($1 == "M") print $2}')

echo "Result:"
echo

for gitFile in ${gitCrlfFiles}; do
    for dirtyFile in ${gitDirtyFiles}; do
        if [[ "${gitFile}" == "${dirtyFile}" ]];then
            echo ${gitFile}
        fi
    done
done
