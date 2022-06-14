#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

BRANCH=$1
PROFILE=$2

if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | test | local }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

function pull() {
  echo -e ""
  echo -e ">> Git Pull"
  git pull origin $BRANCH
}

function build() {
  echo -e ""
  echo -e ">> Gradle Clean & Build"
  ./gradlew clean build -x test
}

function search_pid() {
  echo "$(jps | grep "subway" | awk '{print $1}')"
}

function stop_server() {
  local pid="$1"
  echo -e ""
  if [[ -z $pid ]]; then
    echo ">> Not Running Server"
  else
    echo -e ">> Kill Application"
    kill "$pid"
  fi
}

function start_server() {
  echo -e ""
  echo -e ">> Start Server"
  nohup java -jar -Dspring.profiles.active=$PROFILE $(find ./* -name "*.jar" | head -n 1) 1> server.log 2>&1 &

  DEPLOY_PID=$(pgrep -f subway)
  if [ DEPLOY_PID > 0 ]; then
    echo -e ">> Deploy & Start Server"
  fi
}

check_df

pull

build

PID="$(search_pid)"
stop_server "$PID"

start_server