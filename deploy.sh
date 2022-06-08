#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

APP=subway
BRANCH=soob-forest
PID
SHELL_SCRIPT_PATH=$(dirname $0)
EXECUTION_PATH=$SHELL_SCRIPT_PATH/build/libs/subway-0.0.1-SNAPSHOT.jar
LOG_PATH=$SHELL_SCRIPT_PATH/subaway.log

function pull() {
        echo -e ""
        echo -e ">> Pull Request 🏃♂️ "
        git pull origin $BRANCH
}

function build() {
        echo -e ""
        echo -e ">> build 🏃♂️ "
        ./gradlew clean build
}

function findPid(){
        echo -e ""
        echo -e ">> findPid 🏃♂️ "
        PID=$(pgrep -f $APP)
        echo -e $PID
}

function killPid(){
        if [[ -n $PID ]];
        then
                echo -e ""
                echo -e ">> killPid 🏃♂️ "
                echo -e $PID
                kill -15 $PID
        else
                echo -e "is not pid"
        fi
}

function run() {
        echo -e ""
        echo -e ">> run 🏃♂️ "
        nohup java -jar -Dspring.profiles.active=prod $EXECUTION_PATH 1> $LOG_PATH 2>&1 &
}

function input() {
        if [[ -n $1 ]]; 
        then
                BRANCH=$1
        fi
        echo -e $BRANCH
}

input;
pull;
build;
findPid;
killPid;
run;
