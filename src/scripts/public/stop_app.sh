#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << subway app 종료하기 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"


# subway app 종료

PROJECT_NAME=subway
PROJECT_DIR=~/infra-subway-deploy
PROJECT_PID=$PROJECT_DIR/${PROJECT_NAME}.pid

if [[ -f $PROJECT_PID ]]
then
        PID=`cat $PROJECT_PID`
else
        echo "$PROJECT_PID file does not exist."
        exit 0
fi

echo "killing process pid [$PID]"

kill ${PID}

# process down check

RETRY_MAX=10
RETRY_COUNT=0

until [[ ${RETRY_COUNT} -gt ${RETRY_MAX} ]]; do
        PROCESS_NUM=$(ps -ef | grep $PROJECT_NAME | grep ".jar" | grep -v "grep" | grep -v "tail" | wc -l)
        echo "check process down"

        if [[ ${PROCESS_NUM} -eq 0 ]]
        then
                echo "$PROJECT_NAME is stopped"
                rm -v $PROJECT_PID
                exit 0
        fi
        sleep 2
        let RETRY_COUNT=RETRY_COUNT+1
done

# force stop
echo "$PROJECT_NAME failed to stop. FORCE STOP"
kill -9 ${PID}
rm -v ${PROJECT_PID}
exit 0