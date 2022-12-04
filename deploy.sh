#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2
APP_NAME=subway

## 조건 설정
if [[ $# -ne 2 ]]
then
        echo -e "${txtylw}=======================================${txtrst}"
        echo -e "${txtgrn}  << 스크립트 >>${txtrst}"
        echo -e ""
        echo -e "${txtgrn} >> Branch { master | ... } ${txtred} >> Profile { prod | test }${txtrst}"
        echo -e "${txtylw}=======================================${txtrst}"
        exit
fi

function check_df() {
        git fetch
        master=$(git rev-parse ${BRANCH})
        remote=$(git rev-parse origin/${BRANCH})
        if [[ ${master} == ${remote} ]]; then
                echo -e "[$(date)] Nothing to do!!!"
                exit 0
        fi
}

function pull() {
        echo -e ""
        echo -e "${txtylw}>> Pull Request${txtrst}"
        git pull origin baeksoo
}

function build() {
        echo -e ""
        echo -e "${txtpur}[build] ./gradlew clean build${txtrst}"
        ./gradlew clean build
}

function stop() {
        echo -e ""
        echo -e "${txtred}[stop] ${APP_NAME}${txtrst}"
        pkill -f ${APP_NAME}
        echo -e "success"
}

function start() {
        echo -e ""
        echo -e "${txtgrn}[start] ${APP_NAME}${txtrst}"
        nohup java -DAPP_NAME=${APP_NAME} -Dspring.profiles.active=${PROFILE} -jar ${EXECUTION_PATH}/build/libs/subway-0.0.1-SNAPSHOT.jar 1>${APP_NAME}.log 2>&1 &
}

check_df;
pull;
build;
stop;
start;
