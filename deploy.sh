#!/bin/bash

## 변수 설정
BRANCH=$1
PROFILE=$2

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

function pull() {
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin $BRANCH
}

function build() {
  echo -e ">> build 🏃..."
  ./gradlew clean build -x test
}

function get_pid() {
  echo -e "$(jps | grep "subway" | awk '{print $1}')"
}

function kill_app() {
  local pid="$1"
  if [[ -z $pid ]]; then
    echo -e ">> PID Not exist 🏃..."
  else
    echo -e ">> ShutDown server (PID: $pid) 🏃..."
    kill "$pid"
  fi
}

function start_app() {
  echo -e ">> StartUp server (Profile: $PROFILE) 🏃... "
  nohup java -jar \
        -Dspring.profiles.active=$PROFILE \
        $(find ./* -name "*.jar" | head -n 1) \
        1>/home/ubuntu/subway.log \
        2>&1 \
        &
}

## 저장소 pull
pull;

## gradle build
build;

## 프로세스 pid를 찾는 명령어
PID="$(get_pid)";

## 프로세스를 종료하는 명령어
kill_app "$PID";

## 프로세스를 종료하는 명령어
start_app;

