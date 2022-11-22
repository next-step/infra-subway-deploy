#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2
PARAMS_COUNT=$#
APPLICATION_JAR="subway_application.jar"

# 파라미터 체크
function vaildate_params() {
    if [ $PARAMS_COUNT -ne 2 ] || [ $PROFILE != "prod" ];
    then
        echo -e "${txtylw}=======================================${txtrst}"
        echo -e "${txtgrn}  << 실행 명령어 >>${txtrst}"
        echo -e ""
        echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod }"
        echo -e "${txtylw}=======================================${txtrst}"
        exit
    fi
}

# git pull
function git_pull() {
    echo -e "${txtgrn}=======================================${txtrst}"
    echo -e "${txtgrn}  >> git checkout $BRANCH ${txtrst}"
    git checkout $BRANCH

    echo -e "${txtgrn}  >> git pull${txtrst}"
    git pull origin $BRANCH
}

# gradle build
function gradle_build() {
    echo -e "${txtgrn}=======================================${txtrst}"
    echo -e "${txtgrn}  >> gradle build ${txtrst}"
    ./gradlew clean build
}

# rename jar
function rename_jar() {
    mv ./build/libs/*.jar ./build/libs/$APPLICATION_JAR
}

# find process
function find_pid() {
    echo $(pgrep -f $APPLICATION_JAR)
}

# kill application
function kill_pid() {
    if [ -n "$1" ]
    then
        echo -e "${txtgrn}=======================================${txtrst}"
        echo -e "${txtgrn}  >> kill application $1 ${txtrst}"
        kill -15 $1
    fi
}


# start
function start() {
    echo -e "${txtgrn}=======================================${txtrst}"
    echo -e "${txtgrn}  >> start ${txtrst}"
    nohup java -jar -Dspring.profiles.active=$PROFILE ./build/libs/$APPLICATION_JAR > subway.log 2>&1 &
}

# deploy
function deploy() {
    echo -e "${txtgrn}=======================================${txtrst}"
    echo -e "${txtgrn}  >> deploy start ${txtrst}"
    cd $SHELL_SCRIPT_PATH
    vaildate_params
    git_pull
    gradle_build
    rename_jar
    kill_pid $(find_pid)
    start
    echo -e "${txtgrn}  >> deploy finish ${txtrst}"
    echo -e "${txtgrn}=======================================${txtrst}"
}


# run
deploy;
