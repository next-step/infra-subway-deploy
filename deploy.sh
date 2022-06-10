#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

SHELL_SCRIPT_PATH=$(dirname $0)
EXECUTION_PATH=$(pwd)
PROJECT_NAME="infra-subway-deploy"
PROJECT_PATH="$EXECUTION_PATH/$PROJECT_NAME"
BRANCH=$1
PROFILE=$2

## 조건 설정
if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | local }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

## git revision 체크
function check_df() {
  cd ${PROJECT_PATH}

  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

## 저장소 pull
function pull() {
  cd $EXECUTION_PATH

  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  rm -rf $PROJECT_NAME
  git clone -b $BRANCH --single-branch --recurse-submodules https://github.com/handh0413/infra-subway-deploy.git
}

## gradle build
function build() {
  cd $PROJECT_PATH

  echo -e ""
  echo -e ">> Build Project 🏃♂️ "
  cd $PROJECT_NAME
  ./gradlew clean build
}

## 프로세스 종료
function shutdown() {
  PID=`lsof -t -i:8080`
  if [ -n $PID ]; then
    `kill -2 $PID`
	echo -e ""
    echo -e ">> Shutdown Server 🏃♂️ "
  else
    echo -e ">> There is no running server 🏃♂️ "
  fi
}

## 프로세스 실행
function startup() {
  cd $EXECUTION_PATH
  APPLICATION=`find ./* -name "subway-0.0.1-SNAPSHOT.jar"`

  echo -e ""
  echo -e ">> Startup Server 🏃♂️ "
  `nohup java -jar -Dspring.profiles.active=$PROFILE $APPLICATION 1> application.log 2>&1 &`
}

## ...

check_df;
pull;
build;
shutdown;
startup;
