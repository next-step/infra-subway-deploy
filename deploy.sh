#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

BRANCH=$1

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
    do_deploy
  fi
}

function do_deploy() {
  echo -e "${txtgrn}>> do deploy ${txtrst}"
  git_pull
  gradle_build
  find_process
  kill_process
  start_process
}

function git_pull() {
  echo -e "${txtgrn}>> git pull ${txtrst}"
  git pull origin $BRANCH
}

function gradle_build() {
  echo -e "${txtgrn}>> gradle build ${txtrst}"
  ./gradlew clean build
}

function find_process() {
  echo -e "${txtgrn}>> find process ${txtrst}"
  PID=`ps -ef | grep java | grep subway | awk '{print $2}'`
  echo -e "find process id = ${PID}"
}

function kill_process() {
  echo -e "${txtgrn}>> kill process ${txtrst}"
  if [ -z "$PID" ]
  then
    echo "process is not running"
  else
    kill -9 ${PID}
  fi
}

function start_process() {
  echo -e "${txtgrn}>> start process ${txtrst}"
  nohup java -jar -Dspring.profiles.active=prod ./build/libs/subway-0.0.1-SNAPSHOT.jar 1> subway.log 2>&1 &
}

function start_deploy() {
    echo -e "${txtgrn}=======================================${txtrst}"
    echo -e "${txtgrn}  >> deploy start ${txtrst}"
    check_df
    echo -e "${txtgrn}  >> deploy finish ${txtrst}"
    echo -e "${txtgrn}=======================================${txtrst}"
}

start_deploy;
