#!/usr/bin/env bash

clear;
echo "$0" | sed 's/\.\///g' | awk '{print toupper($0)}'
echo "Bash version ${BASH_VERSION}..."

# create the top of the app.js file
# create a list of js files
# loop the through file list
#  invoke yuiCompressor and pipe the result to app.js
# add the bottom of the app.js file
# the end ...

rootDir=$1;
srcDir="${rootDir}/src";
srcFile="";
appFile="${rootDir}/app.js";


function listSourceFiles() {
    cd $1;
    echo $(ls -1 | grep -v map | grep compiled;);
}

function initAppFile() {
    cd $1;
    if [[ -e "app.js" ]]
    then
        sudo rm -f "app.js";
    fi
    echo "(function (app) {" > "app.js";
}

function addAppFileBody() {
    for file in $(listSourceFiles $1)
    do
        filePath="$1/${file}"
        if [[ -e "${filePath}" ]]
        then
            cat "" >> $2
            yuicompressor "${filePath}" >> $2
        fi
    done
}
function completeAppFile() {
    cd $1;
    echo "})(window.app = window.app || {})" >> "app.js";
}

initAppFile ${rootDir}
addAppFileBody ${srcDir} ${appFile}
completeAppFile ${rootDir}
cat ${appFile} | more





