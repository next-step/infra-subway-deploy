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

## branch 변경 확인
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  echo "MASTER $master"
  remote=$(git rev-parse origin/$BRANCH)
  echo "REMOTE $remote"

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

check_df

## 저장소 pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin "$BRANCH"
}

pull

## gradle build
function gradle_build() {
    echo -e ""
    echo -e ">> Gradle Build "
    $EXECUTION_PATH/gradlew clean build
}

gradle_build

## 프로세스 pid를 찾는 명령어
echo -e ""
echo -e ">> Find Pid "
pid=$(ps -ef | grep 'subway' | grep -v 'grep' | awk '{ printf $2 }')

## 프로세스를 종료하는 명령어
function kill_process() {
    echo -e ""
    echo -e ">> Process Kill "

  if [[ "" != "$pid" ]]
  then {
    echo "$pid 프로세스를 종료"
    kill -9 "$pid"
  }
  else {
    echo "지하철 서버 프로세스가 없습니다."
  };fi
}

kill_process

## 프로세스 실행
function run_server() {
    echo -e ""
    echo -e ">> Run Server 🧐"
    nohup java -Djava.security.egd=file:/dev/./urandom -jar -Dspring.profiles.active=$PROFILE  $EXECUTION_PATH/build/libs/subway-*.jar 1> $EXECUTION_PATH/log/server.log 2>&1 &
}

run_server


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 종료 >>${txtrst}"
echo -e ""
echo -e "${txtylw}=======================================${txtrst}"
