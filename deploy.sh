#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

BRANCH=$1
PROFILE=$2

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!!"
  else
    pull;
    build;
    shutdown;
    run;
  fi
}

function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git checkout $BRANCH
  git pull origin $BRANCH
}

function build() {
  echo -e "${txtylw}clean&build app with gradle${txtylw}"
  ./gradlew clean build
}

function shutdown() {
  echo -e "${txtred}shutting down java process${txtred}"
  PID=`ps -eaf | grep java | grep -v grep | awk '{print $2}'`
  if [[ -n "$PID" ]]; then
    kill -9 $PID
    echo -e "${txtred}killed java process${txtred}"
  else
    echo -e "${txtred}java process is not running${txtred}"
  fi
}

function run() {
  echo -e "${txtgrn}starting app${txtgrn}"
  JAR_FILE=$(find ./build -name *.jar)
  sleep 5
  nohup java -jar -Dspring.profiles.active=$PROFILE 1>subway.log 2>&1 $JAR_FILE &
  tail -f subway.log
}

check_df;
