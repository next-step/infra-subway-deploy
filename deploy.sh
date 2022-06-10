#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

EXECUTION_PATH="/home/ubuntu"
PROJECT_NAME="infra-subway-deploy"
PROJECT_PATH="$EXECUTION_PATH/$PROJECT_NAME"
BUILD_NAME="subway-0.0.1-SNAPSHOT.jar"
BRANCH=$1
PROFILE=$2

## 조건 설정

function welcome() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << deploy.sh 🧐 >>${txtrst}"
    echo -e "${txtylw}=======================================${txtrst}"
}

function checkArgumentCount() {
    if [[ $1 -ne 2 ]]
    then
        echo -e "${txtylw}=======================================${txtrst}"
        echo -e "[ERROR] Argument count is only 2 but $1"
        echo -e "input style : ${txtgrn} $0 브랜치이름 ${txtred}{ prod | local }"
        echo -e "${txtylw}=======================================${txtrst}"
        exit
    fi
}

function check_df() {
    git fetch
    master=$(git rev-parse $BRANCH)
    remote=$(git rev-parse origin/$BRANCH)

    if [[ $master == $remote ]]; then
        echo -e "[$(date)] Nothing to do!!! 😫"
        exit 0
    fi
}

function move_project_path() {
    cd $PROJECT_PATH;
}

function pull() {
    echo -e ""
    echo -e ">> Pull Request"
    git pull origin #{BRANCH}
}

function build() {
    echo -e ""
    echo -e ">> $PROJECT_NAME build start"
    git pull origin #{BRANCH}
}

function restart() {
    echo -e ""
    echo -e ">> $PROJECT_NAME restart"

    BUILD_PID=`lsof -t -i:8080`
    if [ -n $BUILD_PID ]; then
        kill -2 $BUILD_PID
        echo -e ""
        echo -e ">> $PROJECT_NAME ($BUILD_PID) kill"
    fi
        
    BUILD_JAR=$(find ./* -name $BUILD_NAME)
    nohup java -jar -Dspring.profiles.active=$PROFILE $BUILD_JAR 1> $PROJECT_NAME.log 2>&1 &
}

welcome;
checkArgumentCount $#;
check_df;
move_project_path;
pull;
build;
restart;