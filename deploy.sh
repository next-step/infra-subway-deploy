#!/bin/bash

## 변수 설정
EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2
PROJECT_NAME=subway

## 저장소 pull
function pull() {
echo -e ""
echo -e ">> Pull Request 🏃♂️ "
git pull origin ${BRANCH}
}


## gradle build
function build() {
echo -e ""
echo -e ">> Build"
./gradlew build
}


## 프로세스 pid를 찾는 명령어
function find_pid(){
echo -e ""
echo -e ">> 실행중인 pid 검색 🏃♂️ "
CURRENT_PID=$(pgrep -f ${PROJECT_NAME}.*.jar)
}


## 프로세스를 종료하는 명령어
function kill_pid(){
echo -e ""
echo -e ">> 실행중인 pid 종료 🏃♂️ "
if [ -z "$CURRENT_PID" ]; then
	echo "> 현재 구동 중인 애플리케이션이 없습니다."
else
	echo "> kill -15 $CURRENT_PID"
	kill -15 $CURRENT_PID
	sleep 5
fi
}


## deploy
function deploy() {
echo -e ""
echo -e ">> 배포 시작 🏃♂️ "
JAR_NAME=$(ls -tr $EXECUTION_PATH/build/libs/ | grep jar | tail -n 1)
echo -e "> jar name: $JAR_NAME"
echo -e "> java -jar -Dspring.profiles.active={$PROFILE} {$EXECUTION_PATH}/build/libs/$JAR_NAME &"

java -jar -Dspring.profiles.active=$2 $EXECUTION_PATH/build/libs/$JAR_NAME &

}

function check_diff(){
git fetch
master=$(git rev-parse $BRANCH)
remote=$(git rev-parse origin $BRANCH)

if [[ $master == $remote ]]; then
        echo -e "[$(date)] Nothing to do!!! 😫"
        exit 0
else
	pull
	build
	find_pid
	kill_pid
	deploy
fi
}

check_diff
