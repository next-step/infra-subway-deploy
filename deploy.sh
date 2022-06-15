#!/bin/bash

TXTRST='\033[1;37m' # White
TXTRED='\033[1;31m' # Red
TXTYLW='\033[1;33m' # Yellow
TXTPUR='\033[1;35m' # Purple
TXTGRN='\033[1;32m' # Green
TXTGRA='\033[1;30m' # Gray

EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

ABSOLUTE_PATH=/home/ubuntu/nextstep
PROJECT_NAME=infra-subway-deploy

function init() {
  if [[ $# -ne 2 ]]
  then
    echo -e ""
    echo -e " ${TXTYLW}=======================================${TXTRST}"
    echo -e " ${TXTYLW} << Project Build ... 🧐 >> ${TXTRST} "
    echo -e ""
    echo -e " ${TXTGRN} 브랜치이름 : $BRANCH ${TXTRED} { prod | dev }"
    echo -e " ${TXTYLW}=======================================${TXTRST}"
    echo -e ""
  else
    exit

    cd $ABSOLUTE_PATH/$PROJECT_NAME
  fi
}

function pull() {
  echo -e ""
  echo -e " >>>> Pull Request 🏃♂ >>>> "
  echo -e ""

  git pull origin $BRANCH
}

function build() {
  echo -e ""
  echo -e " >>>> Gradle Clean & Build 🏃🏃🏃 >>>> "
  echo -e ""

  ./gradlew clean build
}

function kill() {
  CURRENT_PID=$(pgrep -f subway)

  if [ -z $CURRENT_PID ]; then
      echo -e " ${TXTGRN}>> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다.${TXTRST} "
      echo -e ""
  else
      echo -e " ${TXTRED}>> kill -9 $CURRENT_PID${TXTRST}"
      sudo kill -9 $CURRENT_PID

      echo -ne '## (20%)\r'
      sleep 1
      echo -ne '#### (40%)\r'
      sleep 1
      echo -ne '###### (60%)\r'
      sleep 1
      echo -ne '######## (80%)\r'
      sleep 1
      echo -ne '########## (100%)\r'
      sleep 1
      echo -e "${TXTGRN}>>>>> Shutdown 🧐 >>>>"
  fi
}

function start_server() {
  echo -e ""
  echo -e " >>>> Start Server... 🏃♂ >>>> "
  echo -e ""

  nohup java -jar -Dspring.profiles.active=$PROFILE $ABSOLUTE_PATH/$PROJECT_NAME/build/libs/subway-0.0.1-SNAPSHOT.jar 1> $ABSOLUTE_PATH/$PROJECT_NAME/command.log 2>&1 &
}

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
    pull;
    build;
    kill;
    start_server;
  fi
}

init;
check_df;
