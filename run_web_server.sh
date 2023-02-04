#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

APP_PATH='/home/ubuntu/infra-subway-deploy'
JAR_PATH='/home/ubuntu/infra-subway-deploy/build/libs/subway-0.0.1-SNAPSHOT.jar'
EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

function move_directory() {
  cd $APP_PATH
}

function check_df() {
  git fetch
  main=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $main == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 1
  fi
}

function pull() {
  echo -e ""
  echo -e ">>Pull Request 🏃"
  git pull origin $BRANCH
}

function build() {
  echo -e ""
  echo -e "Gradle Build"
  ./gradlew clean build
}

function app_stop() {
  local PID=$(pgrep -f java)
  echo -e ""
  echo -e "Stop App $PID"
  kill -9 $PID
}

function app_start() {
  echo -e ""
  echo -e "Start App"
  nohup java -jar -Dspring.profiles.active=$PROFILE $JAR_PATH 2>&1 &

  echo -e "Started App $(pgrep -f java)"
}

function restart_nginx_docker() {
    docker restart proxy
}

if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치 이름, 실행환경 ${txtred}{ local | prod }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

move_directory;
check_df;
pull;
build;
app_stop;

restart_nginx_docker;
if [[ $PROFILE == "local"]]
then   
    docker restart local_db
fi

app_start;


