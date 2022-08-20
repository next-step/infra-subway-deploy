#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

PID=0
BRANCH=$1
PROFILE=$2
BUILD_FILE=subway-0.0.1-SNAPSHOT.jar

## 저장소 pull
function pull() {
  echo -e ""
  echo -e "${txtpur}>> Pull Request 🏃♂️ ${txtrst}"
  git pull origin $BRANCH
}

## gradle build
function gradle_build() {
  echo -e ""
  echo -e "${txtpur}>> gradle build${txtrst}"
  ./gradlew clean build

}

## 프로세스 pid를 찾는 명령어
function find_pid() {
  echo -e ""
  echo -e "${txtpur}>> find running process id${txtrst}"
  PID=$(pgrep -f ${BUILD_FILE})
  echo -e "${txtred}$PID${txtrst}"
}

## 프로세스를 종료하는 명령어
function kill_pid() {
  echo -e ""
  if [[ $PID == 0 ]]; then
    echo "${txtred}isn't running process${txtrst}"
  else
    echo -e "${txtpur}>> kill process $pid ${txtrst}"
    kill -9 $pid
  fi
}

function deploy() {
  echo -e ""
  echo -e "${txtpur}>> deploy ${txtrst}"
  echo -e "$( find ./* -name "*subway*jar")"
  nohup java -jar -Dspring.profiles.active=${PROFILE} $( find ./* -name ${BUILD_FILE}) >1 nextstep.log 2>&1  &
}

function start() {
  pull;
  gradle_build;
  find_pid;
  kill_pid;
  deploy;
}

## 조건 설정
if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ test | local | prod }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

echo -e $BRANCH
echo -e $PROFILE

start;