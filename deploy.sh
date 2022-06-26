#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray
BRANCH=apio1130
REPOSITORY=/home/ubuntu/nextstep/infra-subway-deploy/
PROJECT_NAME=subway

pull () {
  ## 저장소 pull
  echo "> 저장소 Pull"
  git pull
}

build () {
  ## gradle build
  echo "> gradle build"
  ./gradlew clean build
}

process_kill () {
  ## 프로세스 pid를 찾는 명령어
  CURRENT_PID=$(pgrep -f ${PROJECT_NAME}.*.jar)
  echo $CURRENT_PID

  if [ -z "$CURRENT_PID" ]
  then
    echo "> 현재 실행중인 프로세스가 없습니다."
  else
    ## 프로세스를 종료하는 명령어
    sudo kill -9 $CURRENT_PID
    sleep 5
    echo "> 현재 실행중인 프로세스를 종료했습니다."
  fi
}

deploy () {
  ## 배포
  BUILD_FILE=$(sudo find ./* -name "*subway*jar")
  echo $BUILD_FILE
  java -jar -Dspring.profiles.active=prod $BUILD_FILE &
}

check_df () {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
    pull
    build
    process_kill
    deploy
  fi
}

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

cd $REPOSITORY

check_df

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 종료 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"
