#!/bin/bash


BRANCH=$1
PROFILE=$2

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

function printMessage() {
  local message=$1
  echo -e "${txtgrn}${message}"
}

function move_to_repo() {
  cd /home/ubuntu/infra-subway-deploy
}

## check diff
function check_df() {
  move_to_repo
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    printMessage "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
    printMessage "diff detected!!"
  fi

}

function build() {
  move_to_repo
  git pull origin $BRANCH
  ./gradlew clean build
}

function kill_and_start() {
  ## 프로세스 pid를 찾는 명령어
  ## 프로세스를 종료하는 명령어
  printMessage "kill 8080 port"
  kill $(lsof -t -i:8080)
  printMessage "server start..."
  java -jar -Dspring.profiles.active=$PROFILE ./build/libs/subway-0.0.1-SNAPSHOT.jar ./log_file 2>&1 &
}
