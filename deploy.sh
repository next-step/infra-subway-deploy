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


function pull() {
  echo -e ""
  echo -e "${txtgrn}>> Pull Request 🏃♂️ ${txtrst}"
    git pull origin $1
}

function build() {
  echo -e ""
  echo -e "${txtgrn}>> Build 시작 🏃${txtrst}"
    ./gradlew build
}

function findPid() {
  echo -e ""
  echo -e "${txtgrn}>> 현재 실행 중인 프로세스 pid 확인${txtrst}"
  CURRENT_PID=$(pgrep -f subway)
  echo -e ">> 현재 실행 중인 애플리케이션 pid: $CURRENT_PID"
}

function killPid() {
  echo -e ""
  if [ -z "$CURRENT_PID" ]; then
    echo "${txtylw}>> 현재 실행 중인 애플리케이션이 없습니다.${txtrst}"
  else
    echo "> kill -2 $CURRENT_PID"
    sleep 5
  fi
}

function deploy() {
  JAR_NAME=$(ls -tr $EXECUTION_PATH/build/libs/ | grep jar | tail -n 1)
  echo -e "> jar name: $JAR_NAME"
  nohup jar -jar -Dspring.profiles.active=$2 $EXECUTION_PATH/build/libs/JAR_NAME 2>&1 &
}


function check_df() {
    git fetch
    master=$(git rev-parse $BRANCH)
    remote=$(git rev-parse origin/$BRANCH)

    if [[ $master == $remote ]]; then
      echo -e "[$(date)] Nothing to do!!! 😫"
      exit 0
    else
      pull
      build
      findPid
      killPid
      deploy
    fi
}

## 조건 설정
if [[ $# -ne 2 ]]
then
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
  echo -e ""
  echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
  echo -e "${txtylw}=======================================${txtrst}"
  exit 0
fi
check_df
