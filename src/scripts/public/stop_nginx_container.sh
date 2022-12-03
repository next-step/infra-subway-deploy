#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << nginx container 중지하기 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

# nginx container 중지하기

PROCESS_NAME=proxy
PROCESS_DIR=$HOME/dockerfile
NPID=$PROCESS_DIR/$PROCESS_NAME.pid

if [[ -f ${NPID} ]]
then
        PID=`cat ${NPID}`
else
        echo "$NPID file does not exist"
        exit 0
fi

echo "killing docker process id [$NPID]"

echo "stop"
cat $NPID | xargs -r docker stop

echo "remove"
cat $NPID | xargs -r docker rm

docker ps -a