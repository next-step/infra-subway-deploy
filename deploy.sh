#!/bin/bash

EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

JAR_DIR="${SHELL_SCRIPT_PATH}/build/libs"

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

if [[ $# -ne 2 ]]; then
  echo -e "${txtylw}======================================${txtrst}"
  echo -e "${txtgrn} << 스크립트 🧐 >>${txtrst}"
  echo -e ""
  echo -e "${txtgrn} $0 브랜치 이름 ${txtred}{ prod | dev }"
  echo -e "${txtgrn}======================================${txtrst}"
  exit
fi

function pull() {
        echo -e ""
        echo -e ">> Pull Request 🏃♂️ "
        git pull origin $BRANCH
}

function kill_app() {
  echo -e ">> kill running application"
  currPid=$(pgrep -f "java -jar")
  if [ -z $currPid ]; then
    echo "No running application"
  else
    kill -2 $currPid
    sleep 5
  fi
}

function start_app() {
  echo -e ""
  echo -e "Start application"
  jarFile=$(ls -tr ./build/libs/ | grep jar | tail -n 1)
  nohup java -jar -Dspring.profiles.active=$PROFILE "${JAR_DIR}/${jarFile}" 1> web.log 2>&1 &
}

pull;
check_df;
kill_app;
start_app;

# crontab에서 실행하는 스크립트
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!!  😫"
    exit 1
  else
    git merge origin/$BRANCH
  fi
}
