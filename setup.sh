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
LOG_LOCATION="devlog.log"

function pull() {
    echo -e ""
    echo -e ">> Pull Request"
    git pull origin ${BRANCH}
}

function build() {
    echo -e ""
    echo -e ">> Build start"
    ./gradlew clean build
}

function run() {
    echo -e ""
    echo -e ">> Run Application"
    sudo nohup java -jar -Dspring.profiles.active=${PROFILE} ./build/libs/subway-0.0.1-SNAPSHOT.jar 1> /var/log/subway/${LOG_LOCATION} 2>&1  &
}

function pkill() {
    echo -e ""
    echo -e ">> Kill old process"
    killall java
}

if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

if [ ${PROFILE} == "prod" ]
then
    echo -e "${txtgrn}  << run prod env >>${txtrst}"
    echo -e ">> profile : ${PROFILE}"
    LOG_LOCATION="applog.log"
    echo -e ">> log location : /var/log/subway/${LOG_LOCATION}"
fi

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

pull;
build;
pkill;
run;
