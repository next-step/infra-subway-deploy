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

## 사용법
function usage() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << 배포 스크립트 🧐 >>${txtrst}"
  echo -e ""
  echo -e "${txtgrn}usage: $0 브랜치이름 ${txtred}{ prod | dev }"
  echo -e "${txtylw}=======================================${txtrst}"
}

## 변경 체크
function check_diff() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]
  then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
    start_deploy
  fi
}

## 배포
function start_deploy() {
  echo -e "${txtgrn}[$(date)] ########## deploy start ##########${txtrst}"
  pull
  build
  find_process
  kill_process
  start
  echo -e "${txtgrn}[$(date)] ########## deploy finish ##########${txtrst}"
}

## 저장소 pull
function pull() {
  echo_empty_line
  echo -e "${txtgrn}>> Pull Request 🏃♂️ ${txtrst}"
  git pull origin $BRANCH
}

## gradle build
function build() {
  echo_empty_line
  echo -e "${txtgrn}>> Gradle Clean Build ${txtrst}"
  $EXECUTION_PATH/gradlew clean build
}

## 프로세스 pid를 찾는 명령어
function find_process() {
  echo_empty_line
  echo -e "${txtgrn}>> Find Process Id ${txtrst}"
  PID=`ps -ef | grep java | grep subway | awk '{print $2}'`
  echo -e "Find pid: ${PID}"
}

## 프로세스를 종료하는 명령어
function kill_process() {
  echo_empty_line
  echo -e "${txtgrn}>> Kill Process ${txtrst}"

  if [ -z "$PID" ]
  then
    echo "Process is not running"
  else
    kill -9 ${PID}
  fi
}

## Build 프로그램 실행
function start() {
  echo_empty_line
  echo -e "${txtgrn}>> start process ${txtrst}"
  nohup java -jar -Dspring.profiles.active=prod ./build/libs/subway-0.0.1-SNAPSHOT.jar 1> application.log 2>&1 &
}

function echo_empty_line() {
  echo -e ""
}

if [[ $# -ne 2 ]]
then
  usage
  exit
else
  check_diff
fi
