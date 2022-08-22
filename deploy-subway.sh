#!/bin/bash

#### 변수 설정 ####

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>>>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

## 사용할 변수 선언
EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=main
ACTIVE_PROFILE=prod

cd $EXECUTION_PATH

function build_new() {
  ## gradle build

  echo -e ""
  echo -e ">>>> gradle clean build"
  $EXECUTION_PATH/gradlew clean build

}

function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin $BRANCH
  build_new;
}

## 저장소 확인 / pull
function check_df() {

  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else 
    pull;
  fi
}
## 프로세스 pid 찾기
function find_pid_and_kill() {
  PID=$(pgrep -f ${JAR_FILE_NAME})
  echo ">>>> 종료할 프로세스 pid = $PID"

  ## pid로 프로세스 종료
  echo ">>>> 프로세스 종료하기"
  kill -2 ${PID}
}


check_df;

echo ">>>> 배포할 파일명  $JAR_FILE_NAME"
echo ">>>> 실행할 profile = ${ACTIVE_PROFILE}"

echo -e ""
echo -e ">>>> find jar name"
JAR_FILE_NAME=$(find $EXECUTION_PATH/build/* -name "*jar")

find_pid_and_kill;
echo ">>>> $JAR_FILE_NAME 서비스 $ACTIVE_PROFILE 로 배포"
## 실행하기
nohup java -jar -Dspring.profiles.active=${ACTIVE_PROFILE} ${JAR_FILE_NAME} &


###### END
