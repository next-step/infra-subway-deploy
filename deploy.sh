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

## 브랜치 비교
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ "$master" == "$remote" ]]; then
    echo -e ">> [$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

## 브랜치 pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git checkout $BRANCH
  git pull
}

## 프로젝트 build
function build() {
  echo -e ""
  echo -e ">> Build"
  ./gradlew clean build
}

## 현재 실행 중인 pid 검색
function find_pid() {
  echo -e $(pgrep -f subway)
}

## 기존 프로세스 kill
function kill_process() {
  echo -e ""
  echo -e ">> Kill Process"
  local pid=$(find_pid)

  if [[ $pid -eq 0 ]]
  then
    echo -e ">> process not found"
  else
    kill -2 $pid
    echo -e ">> kill process, pid : $pid"
  fi
}

## 빌드된 jar 파일 위치 검색
function find_jar() {
  find . -type f -name '*.jar' | grep subway
}

## 애플리케이션 실행
function run_app() {
  jarFile=$(find_jar)

  echo -e "==============="
  echo -e ">> Run JarFile : $jarFile"
  echo -e "==============="

  nohup java -jar -Dspring.profiles.active="$PROFILE" "$jarFile" 1> subway.log 2>&1 &
}


if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름[step3] ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

echo -e "${txtylw}=======================================${txtrst}"
echo -e "BRANCH: ${BRANCH} PROFILE : ${PROFILE}"
echo -e "${txtylw}=======================================${txtrst}"

check_df

pull

build

kill_process

run_app

