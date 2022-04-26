#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

BRANCH=$1
PROFILE=$2
REPOSITORY=/home/ubuntu/infra-subway-deploy

## 조건 설정
if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred} { prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

## 저장소 pull
## gradle build
## 프로세스 pid를 찾는 명령어
## 프로세스를 종료하는 명령어
##

function move() {
    cd ${REPOSITORY}
}

function pull() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e ">> Pull Request 🏃♂️ "
    git pull origin ${BRANCH}
    echo -e "${txtylw}=======================================${txtrst}"
}

function build() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e ">> Build Start !!"
    ./gradlew clean build -x test
    echo -e "${txtylw}=======================================${txtrst}"
}

function findPidAndKill() {
    CURRENT_PID=$(pgrep -f java)

    echo -e "CURRENT_PID"

    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 프로세스 종료 🧐 >>${txtrst}"
    if [ -z $CURRENT_PID ]; then
        echo -e "현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
    else
        echo -e "kill -2 $CURRENT_PID"
        kill -2 $CURRENT_PID
        sleep 5
    fi
    echo -e "${txtylw}=======================================${txtrst}"
}

function startServer() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 어플리케이션 배포 🧐 >>${txtrst}"

    JAR_NAME=$(ls ${REPOSITORY}/build/libs | grep 'subway' | tail -n 1)
    echo -e "> JAR Name: $JAR_NAME"

    echo -e "java -Dspring.profiles.active=${PROFILE} -jar ${REPOSITORY}/build/libs/${JAR_NAME} 1> ~/spring.log 2>&1 &"
    java -Dspring.profiles.active=${PROFILE} -jar ${REPOSITORY}/build/lib/${JAR_NAME} 1> ~/spring.log 2>&1 &
    echo -e "${txtylw}=======================================${txtrst}"
}

move;
pull;
build;
findPidAndKill;
startServer;
