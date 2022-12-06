#!/bin/bash

_ROOT_PATH=$(pwd)
_LOG_PATH=/home/ubuntu/nextstep

_APPLICATION_NAME=subway-0.0.1-SNAPSHOT.jar
_BRANCH=wlroh
_PROFILE=prod
_JAVA_OPTION=-Djava.security.egd=file:/dev/./urandom

function pull() {
  echo -e "=========================="
  echo -e "=      Pull Request      ="
  echo -e "=========================="

  check_diff

  git checkout $_BRANCH
  git rebase origin/$_BRANCH

  echo -e ""
}

function check_diff() {
  git fetch origin $_BRANCH
  _local=$(git rev-parse $_BRANCH)
  _remote=$(git rev-parse origin/$_BRANCH)
  if [ $_local == $_remote ]; then
    echo -e "No Change. Stop to deploy"
    echo -e ""
    echo -e "=========================="
    echo -e "=      Stop Deploy       ="
    echo -e "=========================="
    echo -e ""
    exit 1
  fi
}

function build() {
  echo -e "=========================="
  echo -e "=         Build          ="
  echo -e "=========================="

  $_ROOT_PATH/gradlew clean build
  echo -e ""
}

function stop() {
  echo -e "=========================="
  echo -e "=  Shutdown Application  ="
  echo -e "=========================="

  _PID=$(ps -ef | grep java | grep $_APPLICATION_NAME | awk '{print $2}')
  if [ -z $_PID ]; then
    echo "No process is running"
  else
    echo "Kill process"
    kill -9 $_PID
  fi
  echo -e ""
}

function start() {
  echo -e "=========================="
  echo -e "=   Start Application    ="
  echo -e "=========================="

  nohup java $_JAVA_OPTION -Dspring.profiles.active=$_PROFILE -jar $_ROOT_PATH/build/libs/$_APPLICATION_NAME 1> $_LOG_PATH/subway.log 2>&1 &
  echo -e ""
}


echo -e "=========================="
echo -e "=      Start Deploy      ="
echo -e "=========================="
echo -e ""

pull
build
stop
start

echo -e "=========================="
echo -e "=     Success Deploy     ="
echo -e "=========================="
echo -e ""
