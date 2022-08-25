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

## 조건 설정
if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

function check_df() {
  git fetch
  git checkout $BRANCH
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)
  echo $master
  echo $remote

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin $BRANCH
}

function build() {
  echo -e ""
  echo -e ">> Gradle Cleam Build 🏃♂️ "
  $EXECUTION_PATH/gradlew clean build
}

function find_pid() {
  echo -e ""
  echo -e ">> Find Pid 🏃♂️ "
  PID=`ps -ef | grep java | grep subway | grep -v "bash -c" | awk '{print $2}'`
  echo -e "Find pid: $PID "
}

function kill_process() {
  echo -e ""
  echo -e ">> Kill Process 🏃♂️ "
  if [ -z "$PID" ]; then
    echo -e "Process not found 😫"
  else
    kill -9 $PID
    echo -e "Kill -9 $PID"
  fi
}

function find_jar_name() {
  echo -e ""
  echo -e ">> Find Jar Name 🏃♂️ "
  JAR_NAME=$(find $EXECUTION_PATH/build/* -name "*jar")
  echo -e "Find jar file: $JAR_NAME "
}

function run() {
  echo -e ""
  echo -e ">> Run Application: $PROFILE  🏃♂️ "
  if ! [ -d logs ]; then
    mkdir logs
  fi
  nohup java -jar -Dspring.profiles.active=$PROFILE $JAR_NAME 1> $SHELL_SCRIPT_PATH/logs/log.txt 2>&1 &
}

check_df
pull
build
find_pid
kill_process
find_jar_name
run
