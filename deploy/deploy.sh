#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 실행! 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

## 인자 설정
ARGS_COUNT=$#
BRANCH=$1
PROFILE=$2

## 조건 설정
function check_args() {
  if [[ $ARGS_COUNT -ne 2 ]]; then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtred} $0 실행하는데 필요한 인자가 누락됐습니다! ${txtred} "
    echo -e "${txtylw}=======================================${txtrst}"
    exit
  fi
}

## 실행 경로 변경
function cd_execution_path() {
  cd ..
}

## 변경 사항 존재 여부 확인
function check_diff() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 1
  fi
}

## git pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️"
  git pull origin $BRANCH
}

## gradle build
function build() {
  echo -e ""
  echo -e ">> Build Application 🏃♂️"
  ./gradlew clean build
  if [ $? -eq 1 ]; then
    echo -e ">> Fail to build Application!! 😵‍💫 "
    exit 1
  fi
}

## 기존 프로세스 종료
function kill_origin_process() {
  echo -e ""
  echo -e ">> Kill Origin Process!! 🏃♂️"
  origin_pid=$(pgrep -f "java")
  kill $origin_pid

  ## 72번째 프로세스 종료에 실패한 경우에만 실행하도록 변경 필요
  COUNT=1
  while true; do
    if [ -z "$(pgrep -f "java")" ]; then
      echo "kill sigterm. pid=$origin_pid"
      break
    elif [ $COUNT -ge 60 ]; then
      echo "kill sigkill. pid=$origin_pid"
      kill -9 $origin_pid
      break
    fi

    COUNT=$(expr $COUNT + 1)
    sleep 1
  done

  if [ -n "$(pgrep -f "java")" ]; then
    echo "The process that requested kill is still alive. pid=$origin_pid"
    exit 1
  fi
}

## Application 실행
function execute() {
  echo -e ""
  echo -e ">> Execute Application!! 🏃♂️"
  nohup java -jar -Dspring.profiles.active=$PROFILE ./build/libs/*.jar 1>application.log 2>&1 &
}

check_args
cd_execution_path
check_diff
pull
build
kill_origin_process
execute
