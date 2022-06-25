#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"


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
    exit 0
fi

function check_df() {
  git fetch
  main=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $main == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else 
    pull
    build
    find_pid
    run
  fi
}

function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin main
}

function build() {
  echo -e ""
  echo -e ">> 빌드  Start 🏃♂️ "
  ./gradlew clean build
  JAR_NAME=$(basename -- build/libs/*.jar)
  echo -e ">> JAR NAME : ${JAR_NAME}"
}

function find_pid(){
  PID=$(pgrep -f ${JAR_NAME})
  
  if [[ -z "${PID}" ]] 
  then 
    echo ">> 실행 중인 애플리케이션이 없습니다."
  else
    echo "kill -15 ${PID}"
    kill -15 ${PID}
    sleep 5 
  fi 
}

function run(){
  echo ">> 애플리케이션 실행"
  nohup java -jar -Dspring.profiles.active=${PROFILE} build/libs/${JAR_NAME} > ~/log/nohup.out 2>&1 &
}


check_df
