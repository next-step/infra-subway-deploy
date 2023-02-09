#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtylw='\033[1;33m' # Yellow
txtgrn='\033[1;32m' # Green

execution_path=$(pwd)
shell_script_path=$(dirname $0)
branch=$1
profile=$2

function check_parameter() {
  echo ==== check parameter ====
  if [ $1 -ne 2 ]; then
    echo "Invalid Arguments: you need to put two parameter 1.branch name 2.profile" 
    exit 2
  fi
}

function check_df() {
  echo ==== check if remote update ====
  git fetch origin
  master=$(git rev-parse $branch)
  remote=$(git rev-parse origin/$branch)

  if [ $master == $remote ]; then
    echo "[$(date)] Nothing change !"
    exit 0
  fi 
}

function is_server_running() {
  pid=$(ps -ef | grep java | grep subway | awk '{print $2}')
  if [ -n "$pid" ]; then
    echo "true"
  else
    echo "false" 
  fi
}

function git_pull(){
  echo ==== git pull ====
  git pull origin $branch
}

function run_server(){
  echo ==== gradle build ====
  ./gradlew clean build

  echo ==== run server ====
  name=$(find ./ -name "*jar")
  nohup java -jar -Dspring.profiles.active=$profile $name 1> server-log 2>&1 &
}

function kill_running_server(){
  echo ==== kill previous running server ====
  pid=$(ps -ef | grep java | grep subway | awk '{print $2}')
  kill -15 $pid
}

check_parameter $#

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 >>${txtrst}"
echo -e "${txtgrn}  << 브랜치 $branch >>${txtrst}"
echo -e "${txtgrn}  << Profile $profile >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

echo "=== go to script path === "
cd /home/ubuntu/nextstep/infra-subway-deploy

echo "==== run server if not running ===="

if [ "$(is_server_running)" = "false" ]; then
  echo "==== there is no running server ===="

  git_pull 
  run_server
  exit 0
fi

echo "==== there is running server ===="

check_df

kill_running_server

git_pull

run_server
