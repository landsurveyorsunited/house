#!/usr/bin/env bash

clear;
echo "$0" | sed 's/\.\///g' | awk '{print toupper($0)}'
echo "Bash version ${BASH_VERSION}..."

_csvFile="data.csv"
_jsonFile="data.json"
_minJsonFile="data.min.json"
_fieldFile="fields.conf"


if [ "$#" -eq 1 ]; then _csvFile=$1; fi
if [ "$#" -gt 1 ]; then _jsonFile=$2; fi
if [ "$#" -gt 2 ]; then _fieldFile=$3; fi



function parseFile() {
    if [[ -e $1 ]]
    then
        cat $1 | sed -e 's/^[[:space:]]*//'
    fi
}

function increment() {
    rc=`expr $1 + 1`;
    echo ${rc};
}

function parseFileLine() {
    config=$1;
    line=$2;
    lines=$(parseFile ${config};);
    echo ${lines[${line}]};
}

function rowCount() {
    cnt=$(wc -l $1;)
    echo ${cnt};
}

function startRoot() {
    echo "{" > $1
    echo "\"data\": [" >> $1
}

function endRoot() {
    rowCount=$(rowCount);
    echo "]," >> $1
    echo "\"totalCount\": ${rowCount} }" >> $1
}

function parseMonth() {
    rc=0;
    case $1 in
      'Jan')
        rc=01;
        ;;
      'Feb')
        rc=02;
        ;;
      'Mar')
        rc=03;
        ;;
      'Apr')
        rc=04;
        ;;
      'May')
        rc=05;
        ;;
      'Jun')
        rc=06;
        ;;
      'Jul')
       rc=07;
        ;;
      'Aug')
        rc=08;
        ;;
      'Sep')
        rc=09;
        ;;
      'Oct')
        rc=10;
        ;;
      'Nov')
        rc=11;
        ;;
      *)
        rc=12;
        ;;
    esac
    echo "${rc}";
}


function parseDay() {
    rc="";
    digit=$(echo "$1";);

    case "${digit}" in
        "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9")
          rc=$(echo "0${digit}";);
          ;;
        *)
          rc=$(echo "${digit}");
        ;;
    esac
    echo "${rc}";
}

function parseDate() {
    string=$(echo "$1";);
    array=(${string//-/ });
    day=$(echo "${array[1]}";);
    month=$(echo "${array[0]}";);
    year=$(echo "${array[2]}";);
    echo -e "${year}-${month}-${day}";
}

function adjustHour() {
    echo $(($1+12));
}

function convertToEpoch() {
    _date=$1
    echo $(date -j -f "%Y-%m-%d" "${_date}" "+%s";)
}

function parseTime() {
    string="$1";
    array=(${string//:/ });
    hour=${array[0]};
    minute=${array[1]};
    second=${array[2]};
    ampm=${array[3]};

    if [[ ampm -eq "PM" ]]
    then
        if [[ ${hour} -ne "12" ]]
        then
            hour=$(adjustHour "${hour}";);
        else
            hour=$(echo "00";);
        fi
    fi
    echo -e "${hour}:${minute}:${second}";
}


function addNode() {
    line=$1;
    fields=$3;
    keys=(${fields//,/ });
    values=(${line//,/ });
    date=$(parseDate "${values[0]}";);
    epochDate=$(convertToEpoch "${date}";);
    echo -e "{\"${keys[0]}\": \"${values[0]}\"," >> $2;
    echo -e "\"${keys[1]}\": \"${values[1]}\"," >> $2;
    echo -e "\"${keys[2]}\": \"${values[2]}\"," >> $2;
    echo -e "\"${keys[3]}\": \"${epochDate}\"}," >> $2;
}

function addArrayNode() {
    line=$1;
    newline=$(echo "${line}" | sed 's/,/","/g';);

    echo -e "[\"${newline}\"]," >> $2
}

function minifyFile() {
    cat $1 | tr '\n' ' ' > $2
}
function main() {
    startRoot ${_jsonFile};

    while read line; do
        addArrayNode "${line}" "${_jsonFile}";
    done < ${_csvFile}

    endRoot ${_jsonFile};
    minifyFile "${_jsonFile}" "${_minJsonFile}";
}


main;


