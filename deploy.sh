#!/bin/bash

PROJECT_PATH=/home/ubuntu/nextstep/infra-subway-deploy
EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

## 조건 설정
function start() {
  if [[ $# -ne 2 ]]
  then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtgrn}  << 파라미터 확인 >> 브랜치명${BRANCH} PROFILE${PROFILE}${txtrst} "
    echo -e "${txtylw}=======================================${txtrst}"
  else
    echo -e "${txtred} 파라미터의 개수가 맞지 않습니다.${txtrst}"
    echo -e "$# 개가 입력되었습니다."
  fi
}

## 저장소 pull
function pull() {
  echo -e ""
  echo -e ">> Pull origin ${BRANCH} 🏃♂️ "
  sudo -u ubuntu -- git pull origin ${BRANCH}
}

## gradle build
function build() {
  echo -e ""
  echo -e ">> Gradle clean build 🏃♂️ "
  sudo ./gradlew clean build
  JAR_NAME=$(basename -- build/libs/*.jar)
  echo -e ">> JAR NAME : ${JAR_NAME}"
}

## 프로세스를 종료하는 명령어
function kill_pid() {
  CURRENT_PID=$(pgrep -f ${JAR_NAME})
  echo -e ">> 실행 중인 애플리케이션 pid 확인: ${CURRENT_PID} 🏃♂️ "

  if [[ -z "${CURRENT_PID}" ]]
          then
          echo ">> 실행 중인 애플리케이션이 없습니다."
  else
          echo "kill -15 ${CURRENT_PID}"
          sudo kill -15 ${CURRENT_PID}
  sleep 5
  fi
}

## app 시작
function run() {
  echo -e ">> App 시작 🏃♂️ "
  JAR_NAME=$(basename -- build/libs/*.jar)
  sudo nohup java -jar -Dspring.profiles.active=${PROFILE} build/libs/${JAR_NAME} &
}

## git branch 변경
function check_df(){
  echo -e ">> Git Branch 변경 확인 🏃♂️ "
  sudo -u ubuntu -- git fetch
  main=$(sudo -u ubuntu -- git rev-parse ${BRANCH})
  remote=$(sudo -u ubuntu -- git rev-parse origin/${BRANCH})

  if [[ $main == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
    echo -e ">> 브랜치가 변경되었습니다."
    pull
    build
    kill_pid
    run
  fi
}

## 프로젝트 디렉토리 이동
cd ${PROJECT_PATH}
start
check_df
