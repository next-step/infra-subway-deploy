#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << mysql container 중지하기 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

# mysql container 중지하기

DB_NAME=data-subway
DB_DIR=$HOME/db
DB_PID=$DB_DIR/$DB_NAME.pid

if [[ -f ${DB_PID} ]]
then
        PID=`cat ${DB_PID}`
else
        echo "$DB_PID file does not exist"
        exit 0
fi

echo "killing docker process id [$PID]"

echo "stop"
cat $DB_PID | xargs -r docker stop

echo "remove"
cat $DB_PID | xargs -r docker rm

docker ps -a