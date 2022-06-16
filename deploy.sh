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
BRANCH=$1
PROFILE=$2

PROJECT_NAME='subway'
LOG_FILE_PATH='/home/ubuntu/logs/logback.log'

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

function move_working_directory() {
  echo -e ""
  echo -e ">> Move 🏃♂️ : $SHELL_SCRIPT_PATH"
  cd $SHELL_SCRIPT_PATH
  ls -al
}

## 저장소 pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin $BRANCH
}

## gradle build
function build() {
  echo -e ""
  echo -e ">> Run Build 🏃♂️"
  ./gradlew clean build
}

## 프로세스 pid를 찾는 명령어
function find_process_id() {
#  crontab 으로 실행시 알 수 없는 pid가 검출됨
#  pgrep -f $PROJECT_NAME
  ps -ef | grep subway | grep jar | awk '{print $2}'
}

## 프로세스를 종료하는 명령어
function kill_process() {
  pid=$(find_process_id)

  echo -e ""
  echo -e ">> Process Id : $pid"
  echo -e ">> kill Process 🏃♂️"
  kill -9 $pid
}

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

function find_executable_file() {
  find . -type f -name '*.jar' | grep $PROJECT_NAME | grep -v 'gradle'
}

function start_process() {
  jarFilePath=$(find_executable_file)
  echo -e ""
  echo -e ">> jarFilePath : $jarFilePath"
  echo -e ">> Start Process 🏃♂️"
  nohup java -jar -Dspring.profiles.active=prod $jarFilePath 1> $LOG_FILE_PATH 2>&1  &
}

echo -e "${txtylw}=======================================${txtrst}"
echo -e ">> Deploy 🏃♂️ "
echo -e ">> BRANCH: $BRANCH PROFILE : $PROFILE"
echo -e "${txtylw}=======================================${txtrst}"

move_working_directory
check_df
pull
build
kill_process
start_process
