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

function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin "${BRANCH}"
}

function build() {
  echo -e ""
  echo -e ">> Run Build 🏃♂️"
  ./gradlew clean build
}

function find_process_id() {
  pgrep -f "subway"
}

function kill_process() {
  current_process_id=$(find_process_id)

  echo -e "--"
  echo -e "process : $current_process_id"
  echo -e "--"
  echo -e ">> kill Process 🏃♂️"
  kill -9 "$current_process_id"
}

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ "$master" == "$remote" ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

function find_jar() {
  find . -type f -name '*.jar' | grep subway
}

function app_run() {
  jarFile=$(find_jar)

  echo -e "--"
  echo -e "jarFile : $jarFile"
  echo -e "--"

  nohup java -jar -Dspring.profiles.active="$PROFILE" "$jarFile" &
}

## 조건 설정
if [[ $# -ne 2 ]]; then
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
  echo -e ""
  echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
  echo -e "${txtylw}=======================================${txtrst}"
  exit
fi

echo -e "${txtylw}=======================================${txtrst}"
echo -e "BRANCH: ${BRANCH} PROFILE : ${PROFILE}"
echo -e "${txtylw}=======================================${txtrst}"

# Git df
check_df

## 저장소 pull
pull

## gradle build
build

## 프로세스를 종료하는 명령어
kill_process

## 프로세스를 신규로 시작
app_run
