#!/bin/bash
SOURCE_DIR=$1
BRANCH=$2

function check_df() {
  cd $SOURCE_DIR
  git checkout $BRANCH
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

PID=-1
function find_pid_of_older_version_app() {
  PID=`ps -ef | grep java | grep subway | grep -v "bash -c" | awk '{print $2}'`
  if [ -z "$PID" ]; then
    echo -e "[$(date)] Application not found."
  fi
}

function pull() {
  echo -e "️pull"
  git pull origin $BRANCH
}

function kill_older_version_app() {
  echo -e "Older version app is going to be terminated. $PID"
  kill -9 PID
}

function build_new_app() {
  cd $SOURCE_DIR
  echo -e "current directory: $SOURCE_DIR"
  ./gradlew clean build -Dspring.profiles.active=test
}

function execute_app() {
  BUILD_DIR=$SOURCE_DIR/build/libs
  FILE_NAME=`find $BUILD_DIR/*.jar -printf "%f"`
  PATH_TO_EXECUTE=$BUILD_DIR/$FILE_NAME
  nohup java -Djava.security.egd=file:/dev/./urandom -jar -Dspring.profiles.active=prod $PATH_TO_EXECUTE 1> subway.log 2>&1  &
}

check_df;
pull;
find_pid_of_older_version_app;
kill_older_version_app;
build_new_app;
execute_app;