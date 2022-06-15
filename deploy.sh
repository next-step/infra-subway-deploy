#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
SERVICE_PATH=/home/ubuntu/nextstep/infra-subway-deploy

read -p ">> branch 입력 > " BRANCH
read -p ">> profile 입력 > " PROFILE


## 조건 설정
if [ ${PROFILE} != "prod" ] && [ ${PROFILE} != "dev" ]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi


function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin ${BRANCH}
}

function build() {
  echo -e ""
  echo -e ">> build "
  ./gradlew clean build
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

function find_pid() {
  PID=$(ps -ef | grep 'java -jar' | grep -v 'grep' | awk '{ printf $2 }')
  echo ">> Find PID : $PID"
}

function kill_process() {
  echo -e ""
  if [[ $PID -eq 0 ]]
  then
    echo ">> NOT EXIST PROCESS"
  else
  echo -e ">> Kill process $PID"
  kill -9 $PID
  fi
}

function deploy() {
  echo -e ""
  echo -e ">> Deploy Service"
  jarFile=$(find $SERVICE_PATH/build -name "*jar")
  echo -e ">> JarFile : $jarFile"
  nohup java -jar -Dspring.profiles.active=${PROFILE} ${jarFile} 1> $SERVICE_PATH/application.log 2>&1 &
  echo -e "${txtgrn}  << DEPLOY SUCCESS>> ${txtrst}"
}

function start() {
 pull;
 check_df;
 build;
 find_pid;
 kill_process;
 deploy;
}

start;