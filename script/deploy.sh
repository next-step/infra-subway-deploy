#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

PROJECT_NAME='infra-subway-deploy'
JAR_NAME='subway.jar'
BRANCH='step3'

function git_pull() {
  git pull origin step3

  echo "> git pull success!! 🚀"
}

function build() {
  ./gradlew clean build

  echo "> build success!! 🚀"
}

function restart() {
#  read -p "Are you sure you want to restart the app❓[Y/N] > " RESPONSE

#  if [ "$RESPONSE" == "Y" ]; then
    kill_process;
    start_process;
    echo "> restarted subway!! 🚀"
#  else
#    echo "> bye bye 🖐🖐 !! "
#  fi
}

function kill_process() {
  CURRENT_PID=$(pgrep -f ${JAR_NAME})
  echo "> subway pid: $CURRENT_PID"

  ## 프로세스 종료
  if [ -z "$CURRENT_PID" ]; then
    echo "> subway not running..."
  else
    echo "> kill subway[$CURRENT_PID]💀"
    kill $CURRENT_PID
    sleep 5
  fi
}

function start_process() {
  mv ~/$PROJECT_NAME/build/libs/$JAR_NAME ~/subway/$JAR_NAME

  nohup java -Djava.security.egd=file:/dev/./urandom -jar -Dspring.profiles.active=prod ~/subway/$JAR_NAME 1> ~/subway/subway.log 2>&1  &

  echo "> subway start !! 🚀"
}

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << subway deploy start!!! 🚀 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

cd ~/$PROJECT_NAME

check_df;

## 저장소 pull
git_pull;

## build
build;

restart;

