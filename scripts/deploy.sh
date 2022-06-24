#!/bin/bash

## 변수 설정
EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

PROJECT_NAME=infra-subway-deploy
REPOSITORY=/home/ubuntu/nextstep/$PROJECT_NAME

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

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

function pull() {
  echo -e ""
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e ">> Pull Request 🏃"
  git pull origin $BRANCH
  echo -e "${txtylw}=======================================${txtrst}"
}

function build() {
  echo -e ""
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e ">> Gradle clean build 🏃"
  ./gradlew clean build
  echo -e ""
  echo -e ">> Build 파일 복사 🏃"
  cp $REPOSITORY/build/libs/*.jar $REPOSITORY
  echo -e "${txtylw}=======================================${txtrst}"
}

function kill() {
  echo -e ""
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e ">> 현재 구동중인 애플리케이션 pid 확인 🏃"
  CURRENT_PID=$(pgrep -f subway*.jar)
  echo -e "> 현재 구동중인 애플리케이션 pid: $CURRENT_PID"

  if [ -z "$CURRENT_PID" ]; then
    echo "> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."
  else
    echo "> kill -2 $CURRENT_PID"
    kill -2 $CURRENT_PID
    sleep 5
  fi
  echo -e "${txtylw}=======================================${txtrst}"

}

function start() {
  echo -e ""
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e ">> 새 애플리케이션 배포 🏃"
  JARFILE=$(ls -tr $REPOSITORY/ | grep jar | tail -n 1)
  nohup java -jar -Dspring.profiles.active=$PROFILE $JARFILE 1> $REPOSITORY/logs/$PROFILE 2>&1 &
  echo -e "${txtylw}=======================================${txtrst}"
}

## 프로젝트 디렉토리로 이동
cd $REPOSITORY

## 저장소 pull
pull;

## gradle build
build;

# 프로세스 pid를 찾고 종료하는 명령어
kill;

# 프로세스를 시작하는 명령어
start;
