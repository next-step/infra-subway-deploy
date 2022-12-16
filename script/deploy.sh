#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

PROJECT_PATH='/home/ubuntu/nextstep/subway/infra-subway-deploy'
PROFILE=$1

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 배포 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"


function move() {
  echo "function : move"
  cd "$PROJECT_PATH" || exit
}

function check_df() {
  echo "function : check_df"
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 1
  fi
}

function pull() {
  echo "function : pull"
  local branch

  echo -n "branch to pull : "
  read -r branch

  git pull origin "$branch"
}

function build() {
  echo "function : build"

  cd "$PROJECT_PATH"
  ./gradlew clean build
}

function process_kill() {
  echo "function : process_kill"
  local jarFile=$(find ./* -name "*jar")

  pid=$(pgrep -f "${jarFile}")
  if [ -z "${pid}" ]
  then
    echo "> NO RUNNING PROCESS IN PORT 8080"
  else
    echo -e "KILL ${pid}"
    kill -9 "${pid}"
  fi
}

function start_server() {
  echo "function : start_server"
  local jarFile=$(find ./* -name "*jar")
  nohup java -jar -Dspring.profiles.active="${PROFILE}" -Djava.security.egd=file:/dev/./urandom ${PROJECT_PATH}/"${jarFile}" 1> ./subway.log 2>&1 &
}

move;
check_df;
pull;
build;
process_kill;
start_server;