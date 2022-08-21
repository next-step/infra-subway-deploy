#!/bin/bash

## 변수 설정
BRANCH=main
ACTIVE=prod
BUILD_PATH=$(ls ~/nextstep)
JAR_NAME=subway-0.0.1-SNAPSHOT.jar
CURRENT_PID=$(pgrep -f java)

# 컬러 변수
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 시작 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

function pull() {
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin $BRANCH
}

function build() {
  echo "> build 파일명: $JAR_NAME"
  cd $BUILD_PATH

  ./gradlew clean build -Dspring.profiles.active=$ACTIVE
}

function run() {
  if [ -z $CURRENT_PID ]
  then
    echo "> 실행중인 서비스가 없으므로, 서비스를 실행합니다."
  else
    echo "> 실행중인 프로세스 종료"
    kill -15 $CURRENT_PID
    sleep 5
  fi

  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << 어플리케이션 실행 >>${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"

  JAR_PATH=$(find ./* -name "*jar" | grep subway)

  java -jar $JAR_PATH -Dspring.profiles.active=$ACTIVE $JAR_NAME
}

check_df;
pull;
build;
run;
