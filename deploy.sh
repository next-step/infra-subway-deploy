#!/bin/bash

## 변수 설정
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
if [[ $# -ne 2 ]]; then
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
  echo -e ""
  echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | local }"
  echo -e "${txtylw}=======================================${txtrst}"
  exit
else
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
fi

## 저장소 pull
function pull() {
  echo -e ""
  echo -e ">> 레포지토리에서 소스를 받는 중... 🏃♂️ "
  git pull origin $BRANCH
}

## gradle build
function build() {
  echo -e ""
  echo -e ">> 빌드 중 ... 🏃♂️ "
  ./gradlew clean build
}

## subway 프로세스의 pid를 찾는 명령어
function find_pid() {
  echo $(ps -ef | grep "subway" | grep -v grep | awk '{print $2}')
}

## subway 프로세스를 종료하는 명령어
function terminate() {
  local pid=$(find_pid)

  echo -e ""
  echo -e ">> 프로그램 종료 [$pid] 🏃♂️ "

  if [ -z "$pid" ]; then
    echo ">> subway 프로세스를 찾을 수 없습니다. ($pid) 🏃♂️ "
  else
    kill -2 $pid
  fi
}

## JAR파일 찾기
function find_artifact() {
  echo $(find ./* -name "*jar" | grep -v gradle)
}

## subway 프로그램 실행
function start() {
  local artifact_path=$(find_artifact)
  echo -e ""
  echo -e ">> subway 프로그램 시작 [$artifact_path] 🏃♂️ "
  java -jar -Dspring.profiles.active=$PROFILE "$artifact_path" &
}

pull
build
terminate
start
