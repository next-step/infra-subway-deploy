#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

EXECUTION_PATH=$(pwd)
APP_NAME="subway"
BRANCH=$1
PROFILE=$2

## 변경사항 체크
## git 리비전 조회
function checkChangeDiff() {
  echo -e ""
  echo -e "${txtylw}>> ${txtpur}변경사항 체크중!${txtrst}"
  git fetch
  LOCAL=`git rev-parse $BRANCH`
  REMOTE=`git rev-parse FETCH_HEAD`

  if [[ $LOCAL == $REMOTE ]]; then
    echo -e ""
    echo -e "${txtylw}>> ${txtgrn}변경사항이 없습니다~${txtrst}"
    exit 0
  else
    killApp
    pull
    build
    run
  fi
}

## git pull
function pull() {
  echo -e ""
  echo -e "${txtylw}>> ${txtpur}Pull!${txtrst}"
  git pull origin $BRANCH
}

## gradle build
function build() {
  echo -e ""
  echo -e "${txtylw}>> ${txtpur}빌드 시작!${txtrst}"
  ./gradlew clean build
}

## Application PID 확인
## PID로 Application 종료
function killApp() {
  echo -e ""
  echo -e "${txtylw}>> ${txtred}변경사항을 반영하기 위해 Application을 종료합니다.${txtrst}"
  PID=$(pgrep -fl subway | grep java | awk '{print $1}')
  if [ -z "$PID" ]; then
   echo -e "${txtylw}>> ${txtgra}Application이 실행중이 아닙니다.${txtrst}"
  else
   kill -9 $PID
   sleep 5
   echo -e "${txtylw}>> ${txtgrn}Application(${PID})을 종료했습니다.${txtrst}"
  fi
}

## nohup.out이 아닌 subway.log로 로그를 뽑기 위한 설정 추가
## profile을 유동적으로 변경가능
function run() {
  echo -e ""
  echo -e "${txtylw}>> ${txtpur}Application을 실행합니다.${txtrst}"
  JAR_FILE=`find ./build/* -name "*jar"`
  nohup java -jar -Dspring.profiles.active=$PROFILE $JAR_FILE 1> subway.log 2>&1 &
}


## 조건 설정
## 원하는 기능 => 위치 매개변수가 있다면 자동적으로 할당, 없다면 기본값 할당
## $# => 위치 매개변수의 개수가 저장된다.
## -ne => not equal, -eq => equal (bash script Relational Operators)
if [[ $# -eq 2 ]]; then
    echo -e "${txtylw}====================================================${txtrst}"
    echo -e "${txtgrn}                 << 스크립트 🧐 >>${txtrst}"
    echo -e "${txtred}Branch: $BRANCH | Profile: $PROFILE ${txtrst}"
    echo -e "${txtylw}====================================================${txtrst}"
    checkChangeDiff
    exit
else
    BRANCH="masuldev"
    PROFILE="prod"
    echo -e "${txtylw}====================================================${txtrst}"
    echo -e "${txtgrn}                 << 스크립트 🧐 >>${txtrst}"
    echo -e "${txtred}Branch: $BRANCH (default) | Profile: $PROFILE (default) ${txtrst}"
    echo -e "${txtylw}====================================================${txtrst}"
    checkChangeDiff
    exit
fi