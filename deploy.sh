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
FOUND_PID=0

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

## branch 변경 확인 (github branch 변경이 있는 경우)
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}


## 저장소 pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin "$BRANCH"
}


## gradle build
function gradle_build() {
    echo -e ""
    echo -e ">> Gradle Build 🏃♂️ "
    ./gradlew clean build
}


## 프로세스 pid를 찾는 명령어
function find_pid() {
  echo -e ""
  echo -e ">> Find Pid 🏃♂️ "
  FOUND_PID=$(ps -ef | grep 'subway' | grep -v 'grep' | awk '{ printf $2 }')
}


## 프로세스를 종료하는 명령어
function kill_process() {
  echo -e ""
  echo -e ">> Kill Process 🏃♂️ "
  if [[ $FOUND_PID == 0 ]]; then
      echo ">> PID NOT FOUND"
  else
    echo -e ">> Kill process $FOUND_PID"
    kill -9 $FOUND_PID
  fi
}


## 배포
function deploy() {
  echo -e ""
  echo -e ">> Deploy 🏃♂️ "
  jar=$(find $EXECUTION_PATH/build -name "*jar")
  nohup java -jar -Dspring.profiles.active=$PROFILE $EXECUTION_PATH/build/libs/subway-*.jar 1> $EXECUTION_PATH/log/subway.log 2>&1 &
}

## 전체 동작 수행
function start() {
 pull;
 check_df;
 gradle_build;
 find_pid;
 kill_process;
 deploy;
}


start;
