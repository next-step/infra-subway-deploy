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


## 조건 설정
if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi


function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin master
}

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 1
  fi
}

function build() {
  echo -e ""
  echo -e ">> Gradle Clean Build"
  ./gradlew clean build
}

function shutdown() {
  echo -e "Get Current P ID"
  CURRENT_PID="$(pgrep -f ${PROJECT_NAME}.*.jar)"

  if [ -z "$CURRENT_PID" ]; then
	echo -e "> 애플리케이션이 구동 중이지 않아서 종료하지 않습니다."
  else
	echo -e "kill -15 $CURRENT_PID"
	kill -15 $CURRENT_PID
	sleep 2
  fi
}

function run() {
  echo -e "Project Start"
  nohup java -jar -Dspring.profiles.active=$PROFILE ./build/libs/*.jar 2>/home/ubuntu/infra.log 1>&2 &  
}

check_df;
build;
shutdown;
run;

