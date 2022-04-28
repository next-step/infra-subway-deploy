#!/bin/bash

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

function add_safe_dir() {
  git config --global --add safe.directory /home/ubuntu/infra-subway-deploy
}

function move_to_repo() {
  cd /home/ubuntu/infra-subway-deploy
}

## check diff
function check_df() {
  move_to_repo
  git fetch
  master=$(git rev-parse chulhee23)
  printMessage $master

  remote=$(git rev-parse origin/chulhee23)
  printMessage $remote

  if [[ $master == $remote ]]; then
    echo "1"
  else
    echo "0"
  fi

}

function build() {
  move_to_repo
  if [$(check_df) -eq 1]
  then
    git pull origin chulhee23
    ./gradlew clean build
  else
    printMessage "Current Branch is already updated"
  fi
}
function kill_and_start() {
  ## 프로세스 pid를 찾는 명령어
  ## 프로세스를 종료하는 명령어
  printMessage "kill 8080 port"
  kill $(lsof -t -i:8080)
  printMessage "server start..."
  nohup java -jar -Dspring.profiles.active=prod ./build/libs/subway-0.0.1-SNAPSHOT.jar 
}
add_safe_dir;
move_to_repo;
build;
kill_and_start;
