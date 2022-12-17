#!/bin/bash

## 변수 설정

PROJECT_PATH='/home/ubuntu/infra-subway-deploy'
PROFILE=$1
ENV=prod
BRANCH=master

TODAY=$(date)
YYYYMMDD=$(date "+%Y%m%d")
CURRENT_TIME=$(date "+%Y%m%d %H:%M:%S")

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtrst}  << 배포 스크립트 시작 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

## 브랜치 변경점 체크
check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)
  if [[ $master ==  $remote ]]; then
    echo -e "[${TODAY}] Nothing to do"
    exit 0;
  fi
}

## 저장소 pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request"

  CURRENT_BRANCH="$(git branch | awk '{print $2}')"
  echo "===> current branch : ${CURRENT_BRANCH}\n"

  echo "===> check difference"
  check_df

  git pull
}

pull;

## gradle build
${PROJECT_PATH}/gradlew clean build

## 프로세스 pid를 찾는 명령어
PID=$(pidof java)

## 프로세스를 종료하는 명령어
if [ -z "$PID" ]; then
  echo -e "${txtred}  << 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다. >>${txtrst}"
  else
  echo "> kill -15 $PID"
  kill -15 $PID
  sleep 5
fi

## 프로세스를 실행하는 명령어
nohup java -jar -Dspring.profiles.active=prod ${PROJECT_PATH}/build/libs/subway-0.0.1-SNAPSHOT.jar 1> subway.log 2>&1 &

## 프로세스 실행 완료
echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 실행 완료 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"