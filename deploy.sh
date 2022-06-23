#!/bin/bash

## 변수 설정

EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

SRC_PATH=/home/ubuntu/infra-subway-deploy
JAR_PATH=/home/ubuntu/infra-subway-deploy/build/libs
JAR_FILE=subway-0.0.1-SNAPSHOT.jar
LOG_FILE=/home/ubuntu/logs/applog.log

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

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

## 변경여부 확인
function check_diff() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] No changes..."
    exit 0
  fi
}

## 브랜치의 최신 내용 받기
function pull() {
  echo -e ""
  echo -e ">> Pull Request... "
  git pull origin "${BRANCH}"
}

## gradle 클린 빌드
function clean_build() {
  echo -e ""
  echo -e ">> Gradle Cealn Build Start"
  ./gradlew clean build
  echo -e "<< Gradle Cealn Build Finished"
}

## 현재 실행중인 프로세스 화인
function find_pid() {
  echo -e ">> Find Process..."
  CURRENT_PID=$(pgrep -f subway)
  echo -e "<< Process [$CURRENT_PID] is Running... "
}

## 프로세스 종료
function kill_process() {
  echo -e ">> kill process start"
  pid=$(find_pid)
  if [[ $pid == 0 ]]; then
      echo -e "not found execute process"
  else
    echo -e " kill process [$pid]"
    kill -2 $pid
  fi
  echo -e "<< kill process end"
}

## 프로세스 시작
function start_process() {
  echo -e ">> Process Start"
  nohup nohup java -jar -Dspring.profiles.active=$PROFILE $JAR_PATH/$JAR_FILE &
  echo -e "<< Process Finished"
}

## 전체 동작 수행
function start() {
  check_diff;
  pull;
  clean_build;
  find_pid;
  start_process;
  kill_process;
}

start;
