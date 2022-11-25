#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

EXECUTION_PATH=$(pwd)
LOG_FILE_PATH=${EXECUTION_PATH}/nohub.log
BRANCH=$1
PROFILE=$2
PROJECT_NAME=subway
JAR_PATH=${EXECUTION_PATH}/build/libs/

if [[ $# -ne 2 ]]
then
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << 배포 스크립트 🧐 >>${txtrst}"
  echo -e ""
  echo -e "${txtgrn} $0 ${txtred}{ 브랜치이름 } ${txtylw}{ 프로파일 }"
  echo -e "${txtylw}=======================================${txtrst}"
  exit
fi

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  <<  스크립트 🧐 >>${txtrst}"
echo -e ""
echo -e "${txtgrn} $0 ${txtred}$1 ${txtylw}$2"
echo -e "${txtylw}=======================================${txtrst}"

## branch 변경 체크
function check_diff() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

## 저장소 pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request ${BRANCH} 🏃♂️ "
  git pull origin ${BRANCH}
}

## 저장소 checkout
function checkout() {
  echo -e ""
  echo -e ">> checkout ${BRANCH} 🏃♂️ "
  git checkout ${BRANCH}
}

## gradle build
function build() {
  echo -e ""
  echo -e ">> Pull Request ${BRANCH} 🏃♂️ "
  ./gradlew clean build
}

## 어플리케이션 종료
function stopApplication() {
  echo -e ""
  echo -e ">> stop application"
  PID=$(ps -ef|grep java|grep ${PROJECT_NAME}|awk '{print $2}')
  if [[ -n ${PID} ]]
  then killPid
  fi
}

## 프로세스를 찾는 명령어
function findPid() {
  echo "$(ps -ef | grep -v 'grep' | grep ${JAR_PATH} | awk '{print $2}')"
}

## 프로세스를 종료하는 명령어
function killPid() {
  PID=$(findPid)
  echo -e ""
  echo -e ">> Kill pid ${PID}"
  kill ${PID}
}

## 프로젝트 산출물(jar) 파일 경로 확인
function findJar() {
  echo -e ""
  echo -e ">> find jar"
  JAR_FILE=$(find ${EXECUTION_PATH}/* -name '*jar')
}

## 어플리케이션 시작
function startApplication() {
  findJar
  echo -e ""
  echo -e ">> start application"
  nohup java -jar -Dspring.profiles.active=${PROFILE} ${JAR_FILE} 1> ${LOG_FILE_PATH} 2>&1  &
  NEW_PID=$(findPid)
  if [[ -n ${NEW_PID} ]]
  then
    echo -e ">> ${txtgrn}start application success PID : ${NEW_PID}${txtgrn}"
  else
    echo -e ">> ${txtred}start application failed${txtred}"
  fi
}

check_diff
sleep 5
pull
sleep 5
checkout
sleep 5
build
sleep 5
stopApplication
sleep 5
startApplication
