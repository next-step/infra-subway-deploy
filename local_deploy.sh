#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Greena
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"


SOURCE_DIR=/Users/john_park/Desktop/인프라공방/infra-subway-deploy

PID=-1
function find_pid_of_older_version_app() {
  PID=`ps -ef | grep java | grep subway | grep -v "bash -c" | awk '{print $2}'`
  if [ -z "$PID" ]; then
    echo -e "[$(date)] Application not found."
  fi
}

function kill_older_version_app() {
  echo -e "Older version app is going to be terminated. $PID"
  kill -9 $PID
}

function build_new_app() {
  cd $SOURCE_DIR
  echo -e "current directory: $SOURCE_DIR"
  ./gradlew clean build
}

function execute_app() {
  cd $SOURCE_DIR
  echo -e "run java application"
  nohup java -jar -Dspring.profiles.active=test ./build/libs/subway-0.0.1-SNAPSHOT.jar > log.txt 2>&1 &
}


find_pid_of_older_version_app;
kill_older_version_app;
build_new_app;
execute_app;