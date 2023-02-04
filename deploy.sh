#!/bin/bash

## 변수 설정

txtgra='\033[1;30m' # Gray
txtred='\033[1;31m' # Red
txtgrn='\033[1;32m' # Green
txtylw='\033[1;33m' # Yellow
txtblu='\033[1;34m' # Blue
txtpur='\033[1;35m' # Purple
txtrst='\033[1;37m' # White

PROJECT_PATH=/home/ubuntu/nextstep
PROJECT_NAME=infra-subway-deploy
BRANCH=$1
PROFILE=$2

## 조건 설정
if [ $# -eq 1 ]; then
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgra}  << $0 스크립트 실행 실패!🧐 >>${txtrst}"
  echo -e ""
  echo -e "${txtblu} ] 프로파일을 고르세요 : ${txtred}{ prod | local | test}"
  echo -e "${txtylw}=======================================${txtrst}"
  exit
fi

if [ $# -ne 2 ]; then
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgra}  << $0 스크립트 실행 실패!🧐 >>${txtrst}"
  echo -e ""
  echo -e "${txtblu} 당신의 브랜치를 고르세요 : ${txtred}{ main | dev }"
  echo -e "${txtylw}=======================================${txtrst}"
  exit
fi

function start() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << 시작! 🧐 >>${txtrst}"
  cd $PROJECT_PATH/$PROJECT_NAME/ || return
}

function pull() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << 저장소 pull 🏃 >>${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
  git pull origin "$BRANCH"
}

function build() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << 프로젝트 build 🏄 >>${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
  ./gradlew clean build
}

function pid() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << pid 확인 🤖 >>${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"

  CURRENT_PID=$(pgrep -f java | head -1)

  if [ -z "$CURRENT_PID" ]; then
    echo -e "${txtgrn}  << 구동중인 app이 없습니다 🙄 >>${txtrst}"
  else
    echo -e"${txtred} << $CURRENT_PID 프로그램 종료 >>"
    kill -15 "$CURRENT_PID"
    sleep 5
  fi
}

function server() {
  echo -e "${txtgrn}=======================================${txtrst}"
  JAR_REPOSITORY=$PROJECT_PATH/$PROJECT_NAME/build/libs
  cd $JAR_REPOSITORY || return
  JAR_NAME=$(ls -tr "$JAR_REPOSITORY"/ | grep jar)
  echo -e "-Dspring.profiles.active=${PROFILE}"
  echo -e "${JAR_REPOSITORY}${JAR_NAME}"
  nohup java -jar -Dspring.profiles.active="${PROFILE}" "${JAR_REPOSITORY}"/"${JAR_NAME}" 1> nohup.out 2>&1  &
  echo -e "${txtgrn}=======================================${txtrst}"
}

## 시작
start

## 저장소 pull
pull

## gradle build
build

## 프로세스 pid를 찾는 명령어
## 프로세스를 종료하는 명령어
pid

## 서버 시작
server
