#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

PROJECT_NAME=infra-subway-deploy
BRANCH=$1
PROFILE=$2
MESSAGE_MAIL="[infra-subway-deploy] Delploy success!"
TO_MAIL="dlduswo1247@gmail.com"

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

## 1. cd 프로젝트
cd $PROJECT_NAME


## 2. 저장소 pull
function pull() {
  echo -e ">> Git Pull Request.. "
  git pull origin yyy96
}
pull;


## 3. gradle build
function build() {
  echo -e ">> Build Start.. "
  ./gradlew clean build
  echo -e ">> Build Success! "
}
build;

## 4. 프로세스 pid 찾기
function find_pid() {
  PID=$(pgrep -f ".jar$")
  echo -e ">> pid : $PID"
}
find_pid;


## 5. 프로세스를 종료
function kill_process() {
  if [ -z "$PID" ]; then
    echo -e ">> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."
  else
    echo -e ">> Kill Process... "
    kill -15 $PID
    sleep 5
  fi
}
kill_process;

## 6. 배포(완료)
function deploy() {
  JAR_FILE=$(./build/libs/subway-0.0.1-SNAPSHOT.jar)
  echo -e ">> Deploy & Server Start! "
  nohup java -jar -Dspring.profiles.active=prod ${JAR_FILE} &
}
deploy;

## 6-1) 이메일 전송
function send_mail() {
    echo "Hello, this is $(hostname). --- $(date)" | mail -s "${MESSAGE_MAIL}\ $(date)" ${TO_MAIL}
}
send_mail;

## 6-2) github branch 변경이 있는 경우
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH > /dev/null 2>&1)
  remote=$(git rev-parse origin $BRANCH > /dev/null 2>&1)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! "
    exit 0
  fi
}
check_df;