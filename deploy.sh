#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

PID=""
PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

cd $PATH

## 저장소 pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin ${BRANCH}
}

## check df
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 1
  fi
}

## gradle build

function gradle_build() {
  echo -e ""
  echo -e ">> gradle_build 🏃♂️ "
  ./gredlew clean build
}

## 프로세스 pid를 찾는 명령어
PID=$(pgrep -f java)

## 프로세스를 종료하는 명령어
function kill_java() {
  echo -e ""
  echo -e ">> kill java⚔️"
  kill -9 $PID
}

kill_java;

## deploy
function deploy() {
  echo -e ""
  echo -e "deploy java ☕️"
  nohup java -jar -Dspring.profiles.active=$PROFILE build/libs/subway-0.0.1-SNAPSHOT.jar 1>> java.log 2>&1
}

pull;
check_df;
deploy;
gradle_build;
kill_java;
deploy;

