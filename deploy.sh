#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

SUBWAY_PATH="/home/ubuntu/nextstep/infra-subway-deploy"
CONFIG_PATH="/home/ubuntu/nextstep/infra-subway-deploy/src/main/resources/config"
LOG_PATH="/home/ubuntu/nextstep/log"
BRANCH=$1
PROFILE=$2

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 배포 스크립트 시작 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

## github branch 변경 체크
function check_dff() {
  git fetch origin $BRANCH
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo 0
  else
    echo 1
  fi
}

## 저장소 pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin $BRANCH
}

## build
function build() {
  echo -e ""
  echo -e ">> Build"
  ./gradlew clean build
}

## 프로세스 종료
function killProcess() {
  echo -e ""
  echo -e ">> Kill Process"
  CURRENT_PID=$(pgrep -f subway)
  if [[ $CURRENT_PID -gt 0 ]]; then
    echo -e "kill $CURRENT_PID"
    kill -2 $CURRENT_PID
  fi
}

## deploy
function deploy() {
  echo -e ""
  echo -e "${txtylw}>> deploy${txtrst}"
  JAR_PATH=$(find $SUBWAY_PATH/build/libs/* -name "*.jar")
  nohup java -jar -Dspring.profiles.active=$PROFILE $JAR_PATH 1> $LOG_PATH/out.log 2>&1  &
}

## main
MAIN_DFF=$(check_dff);
echo -e "MAIN_DFF=$MAIN_DFF"
if [[ $MAIN_DFF == 1 ]]; then
  pull;
fi

## submodule
cd $CONFIG_PATH
SUB_DFF=$(check_dff);
echo -e "SUB_DFF=$SUB_DFF"
if [[ $SUB_DFF == 1 ]]; then
  pull;
fi

ALL_DFF=$(($MAIN_DFF + $SUB_DFF))
echo -e "ALL_DFF=$ALL_DFF"
if [[ $ALL_DFF == 0 ]]; then
  exit 0
fi

cd $SUBWAY_PATH

## gradle build
build;
## 프로세스 종료
killProcess;
## deploy
deploy;

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 배포 스크립트 종료 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

exit 0
