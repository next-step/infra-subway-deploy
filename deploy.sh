#!/bin/bash

EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

echo -e "${txtred} $SHELL_SCRIPT_PATH"
cd $SHELL_SCRIPT_PATH

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}<< 스크립트 시작🧐 >>"
echo -e "${txtgrn}branch : $BRANCH"
echo -e "${txtgrn}profile : $PROFILE"
echo -e "${txtylw}=======================================${txtrst}"

function pull() {
  echo -e ""
  echo -e "${txtred}Pull"
  git pull origin "${BRANCH}"
}

function check_diff() {
  echo -e ""
  echo -e "${txtred}Check diff"
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 1
  fi
}

function build() {
  echo -e ""
  echo -e "${txtred}Build"
  ./gradlew clean build
}

function find_pid() {
  echo -e ""
  echo -e "${txtred} Find running jar process id"
  pid=$(ps -ef | grep 'jar' | grep 'spring.profiles.active' | grep -v 'grep' | awk '{ printf $2 }')
}


function kill_process() {
  echo -e ""
  if [[ $pid == 0 ]]; then
      echo "${txtred}isn't running jar process"
  else
    echo -e "${txtred}Kill process $pid"
    kill -9 $pid
  fi
}

function deploy() {
  echo -e ""
  echo -e "${txtred}Deploy new jar"
  nohup java -jar -Dspring.profiles.active=${PROFILE} $(find $SHELL_SCRIPT_PATH/build -name "*.jar") 1> /dev/null 2>&1 &
}

pull;
check_diff;
build;
find_pid;
kill_process;
deploy;
