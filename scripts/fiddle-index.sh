#!/bin/bash
# ---------------------------------------------------------------------------------------------------|
#  Repo                    : https://github.com/bradyhouse/house_____________________________________|
#  Specification           : N/A_____________________________________________________________________|
#  Specification Path      : N/A_____________________________________________________________________|
#  Author                  : brady house_____________________________________________________________|
#  Create date             : 03/19/2015______________________________________________________________|
#  Description             : UTILITY USED TO REGENERATE A SPECIFIED FIDDLE INDEX PAGE________________|
#  Command line Arguments  : $1 = FIDDLE TYPE (AKA ../FIDDLE/* SUBDIRECTORY)_________________________|
# ---------------------------------------------------------------------------------------------------|
#  Revision History::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::|
# ---------------------------------------------------------------------------------------------------|
# Baseline Ver.
# 05/01/2015 - See CHANGELOG @ 201505011810
# 05/08/2015 - See CHANGELOG @ 201505061810
# 06/20/2015 - See CHANGELOG @ 201506200420
# 07/05/2015 - See CHANGELOG @ 201506290420
# 07/11/2015 - See CHANGELOG @ 201507110420
# 07/26/2015 - See CHANGELOG @ 201507260420
# 12/06/2015 - See CHANGELOG @ 201511100420
# 02/01/2016 - See CHANGELOG @ 201602010420
# 03/02/2016 - See CHANGELOG @ 201603020420
# 03/10/2016 - See CHANGELOG @ 201603050420
# 04/16/2016 - See CHANGELOG @ 201604160420
# ---------------------------------------------------------------------------------------------------|
echo $(echo "$0" | sed 's/\.\///g') | awk '{print toupper($0)}';
source bin/_utils.sh
source bin/_types.sh


if [ "$#" -ne 1 ]
then
    echo ""
    echo "Nope ~ Incorrect number of arguments"
    echo ""
    echo "Usage:"
    echo ""
    echo "$0 \"[t]\""
    echo ""
    echo "[t] - type. Valid types include: "
    echo ""
    voidEchoFiddleTypes;
    echo ""
    exit
fi

location=$(pwd;)
home=$(cd ~; pwd)
type=$1

fiddleDir=$(cd ..; cd "fiddles/${type}"; pwd;)
fiddleNameStub=$(echo "index";)
indexFile=$(echo "$fiddleDir/index.html";)
binDir=$(echo "$location/bin";)
bornOnDate=$(date +"%m-%d-%y";)
echo ${bornOnDate}

#try
(
    case ${type} in
        'angular'|'angular2'|'aurelia'|'compass'|'extjs5'|'extjs6'|'php'|'rxjs'|'jquery'|'three'|'d3'|'dojo'|'node'|'tween'|'svg')
            case ${type} in
                'php') fiddleName=$(echo "$fiddleNameStub.php";)
                    ;;
                'python') fiddleName=$(echo "fiddle.py";)
                    ;;
                *) fiddleName=$(echo "${fiddleNameStub}.html";)
                    ;;
            esac
            cd $binDir
            cat tpl/indexheader > $indexFile
            cd $fiddleDir
            ls -1 | grep 'fiddle' > index.tmp
            mv index.tmp $binDir
            cd $binDir
            while read line; do
               ignore=$(echo $(cat "../../.gitignore" | grep "${line}" | wc -l;))
               if [[ "${ignore}" -eq "0" ]]
               then
                  echo "<a href=\"$line/$fiddleName\" target=\"_self\">$line</a></br>" >> $indexFile;
               fi
            done < index.tmp
            rm -r index.tmp
            cat tpl/indexfooter >> $indexFile
            $(voidSubstr "{{FiddleType}}" "${type}" "${indexFile}";) || exit 86
            $(voidSubstr "{{BornOnDate}}" "${bornOnDate}" "${indexFile}";) || exit 86
            ;;
        *)  exit 5000
            ;;
    esac
)
#catch
rc=$?
case ${rc} in
    0)  echo "Done. All \"$1\" fiddles have been re-indexed."
        ;;
    86) echo "Error:  Call to the \"bin/house-substr.sh\" script failed."
        ;;
    *)  echo "Error: Something went wrong."
        ;;
esac
#finally
exit ${rc}










