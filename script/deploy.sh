#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

DATE_TIME=`date +'%y%m%d_%H%M%S'`
REPOSITORY=/home/ubuntu/nextstep/infra-subway-deploy
PROFILE=$1
SERVER_NAME=subway

function start() {
        echo -e "${txtylw}=======================================${txtrst}"
        echo -e "${txtgrn}  << 스크립트 >>${txtrst}"
        echo -e "${txtylw}=======================================${txtrst}"
}

function git_pull() {
        cd $REPOSITORY
        ## 저장소 pull
        echo -e "> Git Pull"
        git pull
}

function gradle_build() {
        echo -e "> 프로젝트 Build 시작"
        ./gradlew clean build
}

function mv_log() {
        LOG_DIRECTORY="$REPOSITORY/logs"
        LOG_FILENM="$SERVER_NAME.log"

        NOHUP_LOG_HOME="$REPOSITORY/logs/"
        NOHUP_LOG_FILENM="${SERVER_NAME}_${DATE_TIME}.log"

        cp ${LOG_DIRECTORY}/${LOG_FILENM} ${LOG_DIRECTORY}/${NOHUP_LOG_FILENM}
        cat /dev/null > ${LOG_DIRECTORY}/${LOG_FILENM}
}

function find_kill_daemon() {
        ## 프로세스 pid를 찾는 명령어
        echo -e "> 현재 구동중인 애플리케이션 pid 확인"
        CURRENT_PID=$(pgrep -f subway)
		echo -e "$CURRENT_PID"
        ## 프로세스를 종료하는 명령어
        if [ -z $CURRENT_PID ]; then
                echo -e "현재 애플리케이션 프로세스 없음"
        else
                echo "> kill -2 $CURRENT_PID"
                kill -2 $CURRENT_PID
                sleep 5
                mv_log
        fi
}

function deploy() {
        ## 새 어플리케이션 배포
        echo -e "> 새 어플리케이션 배포"
        JAR_NAME=$(ls $REPOSITORY/build/libs/ | grep 'subway' | tail -n 1)
        echo "> JAR Name: $JAR_NAME"
        nohup java -jar -Dspring.profiles.active=$PROFILE $REPOSITORY/build/libs/$JAR_NAME >> $REPOSITORY/logs/$SERVER_NAME.log 2>&1 &
}

start
git_pull
gradle_build
find_kill_daemon
deploy