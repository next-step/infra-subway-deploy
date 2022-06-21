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
PROJECT_NAME=subway

## 저장소 pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin ${BRANCH}
}

## jar build
function build() {
echo -e ""
echo -e ">> Build 🏃♂️"
 ./gradlew build
}

## 프로세스 pid를 찾는 명령어
function findpid() {
echo -e ""
echo -e ">> 실행중인 Pid 찾기 🏃♂️"
CURRENT_PID=$(pgrep -f ${PROJECT_NAME}.*.jar)
}

## 프로세스를 종료하는 명령어
function killpid() {
echo -e ""
echo -e ">> 실행중인 Pid 중지 🏃♂️"
if [ -z "$CURRENT_PID" ]; then
        echo "> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."
else
        echo "> kill -15 $CURRENT_PID"
        kill -15 $CURRENT_PID
        sleep 5
fi
}

## deploy
function deploy() {
	echo -e ""
	echo -e ">> Deploy🏃♂️"
	JAR_NAME=$(ls -tr $EXECUTION_PATH/build/libs/ | grep jar | tail -n 1)
  	echo -e "> jar name: $JAR_NAME"
  	nohup java -jar -Dserver.port=8080 -Dspring.profiles.active=$2 $EXECUTION_PATH/build/libs/JAR_NAME &
}

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
	pull
	build
	findpid
	killpid
	deploy
  fi
}

## 조건 설정
if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 [step3] ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

check_df
