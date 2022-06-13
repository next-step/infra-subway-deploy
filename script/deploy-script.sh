#!/bin/bash

## 변수 설정
BASE_PATH=/home/ubuntu/nextstep/infra-subway-deploy
BRANCH=$1
PROFILE=$2

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 배포 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

## 저장소 pull
function pull_repository() {
  echo -e ""
  echo -e ">> Change Dir ${BASE_PATH} 🏃♂️"
  cd ${BASE_PATH}
  echo -e ">> Pull Repository 🏃♂️"
  git pull origin ${BRANCH}
}

## gradle build
function build_gradle() {
  echo -e ""
  echo -e ">> Build Gradle 🏃♂️"
  ${BASE_PATH}/gradlew clean build
}

## 프로세스 pid 찾기
function find_pid() {
  echo $(ps -ef | grep jar | grep subway | awk '{ printf $2 }')
}

## 프로세스 종료
function kill_process() {
  echo -e ""
  echo -e ">> Kill Process PID: $1 😫"
  kill -15 $1
}

## jar 파일 찾기
function find_jar() {
  echo $(find ${BASE_PATH}/* -name "*subway*jar")
}

## 어플리케이션 실행
function exec_application() {
  echo -e ""
  echo -e ">> Start Application 🏃♂️"
  echo -e ">> Profile: ${PROFILE}, App Jar: $1 🏃♂️"
  nohup java -jar -Dspring.profiles.active=${PROFILE} $1 1> ${BASE_PATH}/logs/log-subway.log 2>&1  &
}

pull_repository
build_gradle
PID=$(find_pid)
kill_process "${PID}"
APP_JAR=$(find_jar)
exec_application "${APP_JAR}"

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  PID: $(find_pid) ${txtrst}"
echo -e "${txtgrn}  << 배포 완료 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"