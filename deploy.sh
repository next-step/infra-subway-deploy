#!/bin/bash

## 변수 설정
EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2
PROJECT_PATH=/home/ubuntu/nextstep/infra-subway-deploy

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray



function pull() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e ">> Pull Request ${BRANCH} 🏃"
  git pull origin $BRANCH
  echo -e "${txtylw}=======================================${txtrst}"
}


function build() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e ">> Gradle clean build 🏃"
  ./gradlew clean build
  echo -e "${txtylw}=======================================${txtrst}"
}


function kill_running_java_process() {
  echo -e "${txtylw}=======================================${txtrst}"
  CURRENT_PID=$(pgrep -f subway*.jar)

  if [[ -z "${CURRENT_PID}" ]]
          then
          echo ">> 실행 중인 애플리케이션이 없습니다."
  else
          echo -e ">> 실행 중인 애플리케이션의 PID(${CURRENT_PID})를 종료합니다. 🏃"
          echo "kill -15 ${CURRENT_PID}"
          sudo kill -15 ${CURRENT_PID}
          sleep 5
  fi
  echo -e "${txtylw}=======================================${txtrst}"
}


function deploy() {
  echo -e "${txtylw}=======================================${txtrst}"
  JAR_NAME=$(basename -- build/libs/*.jar)
  echo -e ">> Deploy ${JAR_NAME}🏃"

  nohup java -jar -Dspring.profiles.active=$PROFILE $JARFILE 1>log.txt 2>&1 &
  echo -e "${txtylw}=======================================${txtrst}"
}


## 조건 설정
if [[ $# -ne 2 ]]
then
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
  echo -e ""
  echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
  echo -e "${txtylw}=======================================${txtrst}"
  exit
fi

git fetch
master=$(git rev-parse ${BRANCH})
remote=$(git rev-parse origin/${BRANCH})

if [[ $master == $remote ]]; then
  echo -e "[$(date)] Nothing to do !!! 😫"
  exit 0
else
  echo -e "> 브랜치가 변경되었습니다."
  pull
  build
  kill_running_java_process
  deploy
fi

cd ${PROJECT_PATH}