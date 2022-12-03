#!/bin/bash

## 변수 설정
 
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 시작! 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=${1}
PROFILE=${2}
RESTART=${3}

## 조건 설정
if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
fi

function force_restart() {
  if [[ -n "${RESTART}" ]]
  then
    echo ">> 강제 재시동 합니다."
    pull
    build
    kill_old
    start
  else
    check_df
  fi
}
 

function check_df() {
  git fetch
  main=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)
 
  if [[ $main == $remote ]]; then
    echo -e "[$(date)] 변경사항이 없습니다. 😫"
    exit 0
  else 
    echo -e "[$(date)] 변경사항이 있습니다. "
    echo -e ">> 스크립트 동작 시작!!! 🏃♂️ "
    pull
    build
    kill_old
    start
  fi
}

function pull() {
  echo -e ""
  echo -e ">> 깃 PULL 요청 🏃♂️ "
  sudo git pull origin $BRANCH
}

function build() {
  echo -e ""
  echo -e ">> 빌드 시작 🏃♂️ "
  ./gradlew clean build
  JAR_NAME=$(basename -- build/libs/*.jar)
  echo -e ">> JAR NAME : ${JAR_NAME}"
}

function kill_old(){
    PID=$(pgrep -f ${JAR_NAME})
    if [[ -z "${PID}" ]] 
    then 
        echo ">> 현재 실행중인 프로그램이 없습니다."
    else
        echo "kill -15 ${PID}"
        kill -15 ${PID}
        echo ">> 실행중인 프로그램을 종료하였습니다."
        sleep 10 
    fi 
}

function start(){
  echo ">> 애플리케이션을 실행합니다."
  nohup java -jar -Dspring.profiles.active=${PROFILE} build/libs/${JAR_NAME} >> /var/log/application.log 2>&1 &
}

force_restart

