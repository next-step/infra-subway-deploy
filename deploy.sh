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
PROJECT_NAME=infra-subway-deploy
BUILD_NAME=subway-0.0.1-SNAPSHOT

function check_df() {
  git fetch

  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
  else
    pull
  fi
}

## 저장소 pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "

  git pull origin $BRANCH
}

## gradle build
function build() {
  echo -e ""
  echo -e ">> Gradle Build "
  ./gradlew build
}

## 프로세스 pid를 찾는 명령어
function find_process_pid() {
	echo -e ""
	echo -e ">> Find pid"
	CURRENT_PID=$(pgrep -f ${BUILD_NAME}.*.jar)
}

## 프로세스를 종료하는 명령어
function kill_process() {
	if [[ -z "$CURRENT_PID" ]]
	then
		echo -e ""
		echo -e "종료할 프로세스가 없습니다."
	else
		echo -e ""
		echo ">> kill porcess $CURRENT_PID"
		kill -9 $CURRENT_PID
	fi
}

## 프로세스 실행
function start_process() {
  echo -e ""
  echo -e ">> Start Process"
  echo -e ">> nohup java -jar -Dspring.profiles.active=$PROFILE ../build/libs/$BUILD_NAME.jar 1> logfile.txt 2>&1 &"
  nohup java -jar -Dspring.profiles.active=$PROFILE /home/ubuntu/infra-subway-deploy/build/libs/$BUILD_NAME.jar 1> log.txt 2>&1 &
}

if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | local }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

check_df
build
find_process_pid
kill_process
start_process