#!/bin/bash

## 변수 설정

SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

SRC_PATH=/home/ubuntu/nextstep/infra-subway-deploy
DEPLOY_PATH=/home/ubuntu/deploy
DEPLOY_FILE=subway-0.0.1-SNAPSHOT.jar
LOG_FILE=/home/ubuntu/logs/applog.log

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e "${txtgrn}  아래와 같이 브랜치 명과 프로필 명을 입력해주세요.${txtrst}"
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e ""
echo -e "${txtgrn} Branch : $BRANCH\tProfile : $PROFILE${txtrst}"
echo -e "${txtgrn} $(date)${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

## 변경사항 존재여부 확인
function check_diff() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ master == $remote ]]; then
    echo -e "[$(date)] No changes detected."
    exit 0
  fi
}

## Remote 변경사항 pull
function pull_origin() {
  echo -e ""
  echo -e ">> Pull Request Start"
  git pull origin $BRANCH
  echo -e "<< Pull Request Finished"
}

## gradle 빌드
function build_gradle() {
  echo -e ""
  echo -e ">> Build Gradle Start"
  ./gradlew clean build
  echo -e "<< Build Gradle Finished"
}

## 기존 프로세스 종료
function kill_previous_process() {
  pid=`ps -ef | grep -v "grep" | grep subway-0.0.1-SNAPSHOT.jar | awk '{print $2}'`
  if [[ pid == "" ]]; then
    echo -e "Could not found a previous process."
  fi
  echo -e ">> Kill Process(pid=$pid) Start"
  kill -9 $pid
  sleep 5
  echo -e "<< Kill Process(pid=$pid) Finished"
}

## Deploy 용 jar 파일 swap
function swap_deploy_jar() {
  if [ ! -d $DEPLOY_PATH ];then
   mkdir $DEPLOY_PATH
  fi

  if [ ! -e $SRC_PATH/build/libs/$DEPLOY_FILE ];then
    echo -e "[$(date)] Could not found a jar file for deploy."
    exit 0
  fi

  echo -e ">> Remove $DEPLOY_PATH/$DEPLOY_FILE"
  rm $DEPLOY_PATH/$DEPLOY_FILE

  echo -e ">> Copy $SRC_PATH/build/libs/$DEPLOY_FILE -> $DEPLOY_PATH/$DEPLOY_FILE"
  cp $SRC_PATH/build/libs/$DEPLOY_FILE $DEPLOY_PATH/$DEPLOY_FILE
}

## 신규 프로세스 시작
function start_new_process() {
  echo -e ">> Process Starting Start"
  nohup java -jar -Dspring.profiles.active=$PROFILE $DEPLOY_PATH/$DEPLOY_FILE 1> $LOG_FILE 2>&1  &
  echo -e "<< Process Starting Finished"
}

cd $SRC_PATH
check_diff
pull_origin
build_gradle

kill_previous_process
swap_deploy_jar
start_new_process

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 동작완료🧐 >>${txtrst}"
echo -e ""
echo -e "${txtgrn} $(date)${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"
