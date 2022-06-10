#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

REPOSITORY=~/infra-subway-deploy
CURRENT_PID=0

function printTitle() {
        echo ""
        echo -e "${txtylw}>> =================== $1 =================${txtrst}"
}

function printPref() {
        echo -e "${txtylw}================================================================${txtrst}"
}

function pull() {
        printTitle "git pull";
        git pull origin ssamzag
        printPref;
}

function pullSubModule() {
        printTitle "git submodule pull";
        git submodule foreach git pull origin main
        printPref;
}

function build() {
        printTitle "프로젝트 빌드 시작";
        ./gradlew clean build
        printPref;
}
function setPID() {
        printTitle "지하철 애플리케이션 pid 확인";
        CURRENT_PID=$(pgrep -f subway-0.0.1-SNAPSHOT.jar)
        echo "$CURRENT_PID"
        printPref;
}
function killProcess {
        setPID
        printTitle "구동중인 지하철 애플리케이션 확인";
        if [ -z $CURRENT_PID ]
        then
                echo -e "${txtred}> 구동중인 지하철 애플리케이션이 없습니다.${txtrst}"
        else
                echo -e "${txtred}> kill -2 $CURRENT_PID${txtrst}"
                kill -2 $CURRENT_PID
                sleep 5
        fi
        printPref;
}

function run() {
        printTitle "지하철 애플리케이션 실행";
        nohup java -jar -Dspring.profiles.active=prod ./build/libs/subway-0.0.1-SNAPSHOT.jar 1> nohup.out 2>&1 &
        printPref;
}

pull
pullSubModule
build
killProcess
run
