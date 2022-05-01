#!/bin/bash

TXTRST='\033[1;37m' # White
TXTRED='\033[1;31m' # Red
TXTYLW='\033[1;33m' # Yellow
TXTPUR='\033[1;35m' # Purple
TXTGRN='\033[1;32m' # Green
TXTGRA='\033[1;30m' # Gray

ABSOLUTE_PATH=/home/ubuntu/nextstep
PROJECT_NAME=infra-subway-deploy
EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

function check_df() {
  cd $ABSOLUTE_PATH/$PROJECT_NAME

  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

function pull() {
  cd $ABSOLUTE_PATH/$PROJECT_NAME

  echo ""
  echo " >>>> Pull Request 🏃♂ >>>> "
  echo ""

  git pull origin master
}

function build() {
  echo ""
  echo " ${TXTYLW} << Project Build ... >> ${TXTRST} "
  echo ""

  cd $ABSOLUTE_PATH/$PROJECT_NAME

  ./graldew build
}

function get_pid() {
  CURRENT_PID=$(pgrep -f ${PROJECT_NAME}*.jar)
  echo "현재 구동중인 애플리케이션 pid: $CURRENT_PID"

  echo $CURRENT_PID
}

function kill() {
  CURRENT_PID = get_pid;

  if [ -z $CURRENT_PID ]; then
      echo "${TXTGRN}>> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다.${TXTRST}"
      echo ""
  else
      echo "${TXTRED}>> kill -15 $CURRENT_PID${TXTRST}"
      kill -15 $CURRENT_PID
      sleep 5
  fi
}

## 조건 설정
if [ $# -ne 2 ]
then
    echo "${TXTYLW}=======================================${TXTRST}"
    echo "${TXTGRN}  << 스크립트 🧐 >>${TXTRST}"
    echo ""
    echo "${TXTGRN} $0 브랜치이름 ${TXTRED}{ prod | dev }"
    echo "${TXTYLW}=======================================${TXTRST}"
    exit
fi

check_df;
pull;
build;
kill;

## ...