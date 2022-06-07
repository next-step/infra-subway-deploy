#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

## 저장소 pull
EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

## 조건 설정
if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}       << 스크립트시작 방법 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 [브랜치이름] ${txtred}[ prod or dev ]"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

cd /home/ubuntu/nextstep/infra-subway-deploy

## git revision 체크
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

check_df;

## git pull
function pull() {
  echo -e ""
  echo -e ">> Git Pull Request"
  git pull origin $BRANCH
}

pull;

## gradle build
function build() {
  echo -e ""
  echo -e ">> Gradle Clean & Build"
  ./gradlew clean build
}

build;

## 프로세스 pid를 찾는 명령어
function findPid() {
  echo -e ""
  echo -e ">> Find Process ID"
  CURRENT_PID=$(pgrep -f subway)
}

findPid;

## 프로세스를 종료하는 명령어
function shutdownServer() {
  echo -e ""
  echo -e ">> Shutdown Server"
  if [[ -n $CURRENT_PID ]]; then
    kill $CURRENT_PID

    echo -ne '## (20%)\r'
    sleep 1
    echo -ne '#### (40%)\r'
    sleep 1
    echo -ne '###### (60%)\r'
    sleep 1
    echo -ne '######## (80%)\r'
    sleep 1
    echo -ne '########## (100%)\r'
    sleep 1

    echo -e "Graceful Shutdown END <<"
  else
    echo -e "NO Server EXIST <<"
  fi
}

shutdownServer;

## 프로세스를 시작하는 명령어
function startServer() {
  echo -e ""
  echo -e ">> Start Server"
  nohup java -jar -Dspring.profiles.active=$PROFILE $EXECUTION_PATH/build/libs/subway-0.0.1-SNAPSHOT.jar 1> $EXECUTION_PATH/build/libs/catalina.out 2>&1 &

  DEPLOY_PID=$(pgrep -f subway)
  if [ DEPLOY_PID > 0 ]; then
    echo -e "DEPLOY SUCCESS! <<"
  fi
}

startServer;
