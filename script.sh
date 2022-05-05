#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


PROJECT_DIRECTORY=/home/ubuntu/infra-subway-deploy
JAR_PATH=$(find ./* -name "*jar")
BRANCH=$1
PROFILE=$2

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

function moveToRepo() {
  cd ${PROJECT_DIRECTORY}
}

function checkoutRepoAndPull() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  ${BRANCH} REMOTE BRANCH PULL ${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"

  git checkout ${BRANCH}
  git pull origin ${BRANCH}
}

function build() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn} build start ${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"

  ./gradlew clean build
}

function killProcess() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn} infra-subway-deploy process kill ${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"

  fuser -k 8080/tcp
}

function serverStart() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn} server start ${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"

  nohup java -jar -Dspring.profiles.active=${PROFILE} ${JAR_PATH} &
}

moveToRepo
checkoutRepoAndPull
build
killProcess
serverStart