#!/bin/bash

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

function cd_execution_path() {
  cd "$HOME/nextstep/infra-subway-deploy" || exit 1
  EXECUTION_PATH=$(pwd)
  echo -e "pwd=$EXECUTION_PATH"
}

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 1
  fi
}

function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin $BRANCH && echo SUCCESS || (echo FAIL && exit 1)
}

function build() {
  echo -e ""
  echo -e ">> gradle build 🏃♂️ "
  ./gradlew clean build
  if [ $? -eq 0 ]; then
     echo OK
  else
     echo FAIL
     exit 1
  fi
}

function kill_process() {
  echo -e ""
  echo -e ">> kill process 🏃♂️ "
  ori_pid=$(pgrep -f "java.*subway")
  [[ ! -z "$ori_pid" ]] && echo -e "$ori_pid" && kill "$ori_pid"
}

function run() {
  echo -e ""
  echo -e ">> run application 🏃♂️ "
  java -Dspring.profiles.active="$PROFILE" -jar build/libs/subway-0.0.1-SNAPSHOT.jar > logs/app.log &
}

## 조건 설정
if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 ${BRANCH} ${txtred} $PROFILE"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

cd_execution_path;
check_df;
pull;
build;
kill_process;
run;

