#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

REPOSITORY=https://github.com/bluewow/infra-subway-deploy.git
BRANCH=main
PROFILE=$1
PROJECT=subway


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtgrn}  << BRANCH 🧐 >> "$BRANCH
echo -e "${txtgrn}  << PROFILE 🧐 >> "$PROFILE
echo -e "${txtylw}=======================================${txtrst}"


function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH > /dev/null 2>&1)
  remote=$(git rev-parse origin $BRANCH > /dev/null 2>&1)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

## 저장소 pull
#check_df;
echo -e ""
echo -e ">> Pull Request 🏃♂️ "
git pull $REPOSITORY

## gradle build
./gradlew build;

## 프로세스 pid를 찾는 명령어
PID=$(pgrep -f ${PROJECT}.*.jar)

## 프로세스를 종료하는 명령어
if [ -n ${PID} ]; then
        echo "> kill -15 $PID"
        kill -15 $PID
        sleep 2
fi

## 프로세스 시작
JAR_NAME=$(find -name *SNAPSHOT.jar)
nohup java -jar -Dspring.profiles.active=$PROFILE $JAR_NAME &

