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

if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn} << 스크립트 >> ${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 infra-subway ${txtred}{ prod }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

function check_df() {
  echo -e "${txtylw}============check_df exec=======================${txtrst}"
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
    start;
  fi
  echo -e "${txtylw}============check_df end=======================${txtrst}"
}

function pull() {
  echo -e "${txtylw}============git pull exec=======================${txtrst}"
  git pull origin $BRANCH
  echo -e "${txtylw}============git pull end=======================${txtrst}"
}

function clean_build() {
  echo -e "${txtylw}============git clean_build exec=======================${txtrst}"
  ./gradlew clean build
  echo -e "${txtylw}============git clean_build end=======================${txtrst}"
}

function find_pid() {
  echo -e "${txtylw}============git find_pid exec=======================${txtrst}"
  current_pid=$(pgrep java | head -1)
  echo $current_pid}
  echo -e "${txtylw}============git find_pid end=======================${txtrst}"
}

function kill_process() {
  echo -e "${txtylw}============git kill_process exec=======================${txtrst}"
  pid=$(find_pid)
  if [[ $pid == 0 ]]; then
      echo -e "${txtylw}============not found execute process=======================${txtrst}"
  else
    echo -e "${txtred}==================kill process ($pid)=================${txtrst}"
    kill -2 $pid
  fi
  echo -e "${txtylw}============git kill_process end=======================${txtrst}"
}

function run() {
  jar_name=$(ls -tr $EXECUTION_PATH/build/libs | grep jar | tail -n 1)
  nohup java -jar -Dspring.profiles.active=${PROFILE} ${EXECUTION_PATH}/build/libs/${jar_name} 1> infra-prod 2>&1 &
}

function start() {
  pull;
  clean_build;
  kill_process;
  run;
}

check_df;