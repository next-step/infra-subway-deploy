#!/bin/bash

START_TIME=`date +%s.%N`
EXECUTION_PATH=$(pwd)
EXECUTION_FILE=${0}
SHELL_SCRIPT_RELATIVE_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

function print_variables() {
  echo -e ""
  echo -e EXECUTION_PATH : ${EXECUTION_PATH}
  echo -e EXECUTION_FILE : ${EXECUTION_FILE}
  echo -e SHELL_SCRIPT_RELATIVE_PATH : ${SHELL_SCRIPT_RELATIVE_PATH}
  echo -e BRANCH : ${BRANCH}
  echo -e PROFILE : ${PROFILE}
}

function git_clone() {
  git clone -b ${BRANCH} --single-branch ${GIT_URL}
}

function git_checkout() {
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [ "$CURRENT_BRANCH" != "$BRANCH" ]; then
    git fetch origin ${BRANCH}:${BRANCH}
  else
    git fetch
  fi
  git checkout ${BRANCH}
}

function git_pull() {
  git pull origin ${BRANCH}
}

function confirm_difference() {
  if [ -n "$(git status --porcelain)" ]; then
    echo -e ""
    echo -e "$(git status --porcelain)"
    exit 0
  fi

  HASH=$(git rev-parse HEAD)
  REMOTE_HASH=$(git rev-parse --verify origin/$BRANCH)
  if [ $HASH != $REMOTE_HASH ]; then
    echo -e ""
    echo -e "NO DIFFERENCE ..."
    print_execution_time
    exit 0
  fi

  gradle_build

  terminate_process

  execute_process

  print_execution_time
}

function gradle_build() {
  gradle clean build
}

function terminate_process() {
  PID=`ps -eaf | grep java | grep -v grep | awk '{print $2}'`
  echo -e ""
  echo -e PID : ${PID}
  if [ "$PID" !=  "" ]; then
    kill -9 $PID
  fi
}

function run_process() {
  JAR_NAME=$(ls -tr build/libs | grep jar | tail -n 1)
  nohup java -jar build/libs/${JAR_NAME} --spring.profiles.active=${PROFILE} 1> subway.log 2>&1 &
}

function print_execution_time() {
  END_TIME=`date +%s.%N`
  EXECUTION_TIME=$(echo "$END_TIME - $START_TIME" | bc -l)
  echo -e EXECUTION_TIME : ${EXECUTION_TIME}s
}

if [ $# -ne 2 ] ; then
  echo ""
  echo "MISSING PARAMETERS"
  exit 0
fi

print_variables

git_checkout

confirm_difference
