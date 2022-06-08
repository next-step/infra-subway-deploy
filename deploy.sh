#!/bin/bash


EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐  >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

## 저장소 pull
function pull(){
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin main
}

## check df
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi

}

## gradle clean build
function gradle_clean_build(){
  ./gradlew clean build
}

## 프로세스를 종료하는 명령어
function app_process_kill(){
  kill -9 $(ps -ef | grep build/libs |grep -v grep | awk '{print $2}')
  echo -e "app kill success"
 # $PID = `ps -ef | grep 'build/libs' | awk '{print $2}'`
 # if ["${#PID}"!=0 ]; then
 #   kill -9 $PID
 #   echo -e "$PID kill success"
 # else
 #   echo -e "running proess not found"
 # fi
}

## 프로세스를 시작하는 명령어
function app_process_start(){
  nohup java -jar -Dspring.profiles.active=$PROFILE $EXECUTION_PATH/build/libs/*.jar 1> subway.log 2>%1 &
}


echo -e ""
echo -e ">> check_df"
check_df;
if [ $? = 1 ]; then
  echo -e ""
  echo -e ">> check_df error"
  exit 0
fi

## git pull
echo -e ""
echo -e ">> git pull"
pull;
if [ $? = 1 ]; then
  echo -e ""
  echo -e ">> git pull error"
  exit 0
fi

## gradle build
echo -e ""
echo -e ">> gradle clean build"
gradle_clean_build;
if [ $? = 1 ]; then
  echo -e ""
  echo -e ">> gradle build error"
  exit 0
fi

## process kill
echo -e ""
echo -e ">> app process kill"
app_process_kill;

## process start
echo -e ""
echo -e ">> app process start"
app_process_start;
if [ $? = 1 ]; then
  echo -e ""
  echo -e ">> app process start fail"
  exit 0
fi
