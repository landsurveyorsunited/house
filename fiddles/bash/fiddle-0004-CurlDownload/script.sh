#!/usr/bin/env bash

clear;
echo "$0" | sed 's/\.\///g' | awk '{print toupper($0)}'

curl https://www.jetbrains.com/idea/download/download-thanks.html?platform=mac -o intelliJ.zip
