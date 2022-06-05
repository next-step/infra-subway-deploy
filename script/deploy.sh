#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 배포 스크립트 $0 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

BRANCH=$1
PROFILE=$2
BASE_DIR=/home/ubuntu/nextstep/infra-subway-deploy

function check_arguments() {
  if [ $# -ne 2 ] || [ $1 -e "-h" ] || [ $1 -e "--help" ]; then
      echo "Arguments Are Not Enough"
      help_message
      exit
  fi
}

function help_message() {
    echo "*** $0 Script Instruction ***"
    echo "$0 {branch_name} {profile}"
}

## 저장소 pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin ${BRANCH}
}

## gradle build
function gradle_build() {
  echo -e ""
  echo -e ">> Gradle Build 🏃♂️ "
  cd ${BASE_DIR}
  ./gradlew clean build -x test
}

## 프로세스 pid 검색
function get_pid() {
    echo "$(ps -ef | grep 'subway' | grep -v 'grep' | awk '{ printf $2 }')"
}

## 프로세스를 종료

function kill_app() {
  PID="$1"
  echo -e ""
  if [[ -z ${PID} ]]; then
    echo ">> Not Exist PID "
    exit
  else
    echo "Kill Application PID: ${PID}"
    kill -15 ${PID}
  fi
}

## 어플리케이션 파일 이름 검색
function find_app_name() {
    echo "$(find ./* -name "*.jar" | grep "subway")"
}

## 어플리케이션을 실행
function start_app() {
  local appName="$1"
   echo -e ""
   echo "Start Application "
   nohup java -jar \
          -Dspring.profiles.active=${PROFILE} \
          ${appName} \
          1>application.log \
          2>&1 \
          &
}
pull
gradle_build
PID=$(get_pid)
echo $PID
APP_NAME=$(find_app_name)
echo $APP_NAME
