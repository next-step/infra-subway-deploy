#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git checkout imcool2551
  git pull upstream imcool2551
}

function build() {
  echo -e "${txtylw}clean&build app with gradle${txtylw}"
  ./gradlew clean build
}

function kill() {
  echo -e "${txtred}kill running app before restart${txtred}"
  PID=$(ps -ef | grep java | awk '{ print $2 }')
  if [ -n "$PID" ]; then
    echo -e "${txtylw}app is not running${txtylw}"
  else
    kill -9 $PID
    echo -e "${txtylw}app with id of ${PID} is killed"
  fi
}

function run() {
  echo -e "${txtgrn}starting app${txtgrn}"
  JAR_FILE=$(find ./build -name *.jar)
  sleep 5
  nohup java -jar $JAR_FILE -DSpring.profiles-active=prod 1>subway.log 2>&1 &
}

pull;
build;
kill;
run;
