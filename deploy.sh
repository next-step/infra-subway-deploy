#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2
JAR_NAME="subway-0.0.1-SNAPSHOT.jar"

## 저장소 변경 사항 확인
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "${txtred}>> [WARN][$(date)] Repository의 변경 사항이 없습니다.${txtrst}"
    exit 0
  fi
}

## 저장소 pull
function pull() {
  echo -e ""
  echo -e "${txtgrn}>> [INFO][$(date)] 소스코드를 최신 버전으로 갱신합니다. ${txtrst}"
  echo -e "${txtgrn}>> [INFO][$(date)] cmd : git pull origin ${BRANCH}${txtrst}"
  git pull origin ${BRANCH}
}

## gradle test & build
function build() {
  echo -e ""
  echo -e "${txtgrn}>> [INFO][$(date)] 최신버전 어플리케이션을 빌드합니다. ${txtrst}"
  echo -e "${txtgrn}>> [INFO][$(date)] cmd : ./gradlew clean build${txtrst}"
  ./gradlew clean build
}

## 프로세스 종료
function kill_pid() {
  echo -e ""
  PID=$(pgrep -f ${JAR_NAME})

  if [ -z "${PID}" ];
  then
    echo -e "${txtred}>> [WARN][$(date)] 실행중인 ${JAR_NAME}이 없습니다. ${txtrst}"
  else
    sig_term
    kill_check
  fi
}

## 이전 프로세스 종료 여부 확인
function kill_check() {
  # if [ -z target ] -> null : true
  sleep 5
  if [ ! -z "${PID}" ];
  then
    sig_kill
    echo -e "${txtgrn}>> [INFO][$(date)] 실행중인 ${JAR_NAME}이 종료되지 않아 강제 종료 합니다. PID : ${PID} ${txtrst}"
  else
    echo -e "${txtgrn}>> [INFO][$(date)] 실행중인 ${JAR_NAME}이 종료되었습니다. PID : ${PID} ${txtrst}"
  fi
}

## 프로세스 종료
function sig_term() {
  kill -15 ${PID}
}

## 프로세스 강제 종료
function sig_kill() {
  kill -9 ${PID}
}

## 어플리케이션 배포
function deploy() {
	echo -e ""
	echo -e "${txtgrn}>> [INFO][$(date)] 어플리케이션을 배포합니다. ${txtrst}"
  nohup java -jar -Dserver.port=8080 -Dspring.profiles.active=$PROFILE $EXECUTION_PATH/build/libs/$JAR_NAME 1> infra-subway-deploy-log 2>&1 &

  PID=$(pgrep -f ${JAR_NAME})
  echo -e "${txtgrn}>> [INFO][$(date)] 어플리케이션이 시작되었습니다. PID : ${PID} ${txtrst}"
}

## 전체 배포 step 실행
function process() {
  check_df
  pull
  build
  kill_pid
  deploy
}

## script 실행 시, 조건 설정
echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
if [[ $# -ne 2 ]]
then
    echo -e ""
    echo -e "${txtylw} $1 해당 Repo의 브랜치명을 입력하세요 :${txtred}$(git remote show origin | grep 'Fetch URL')"
    echo -e "${txtylw} $2 해당 Repo를 실행할 구동환경을 입력하세요 :${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
else
    echo -e ""
    echo -e "${txtgrn} [Branch] : $BRANCH ${txtrst}"
    echo -e "${txtgrn} [Profile] : $PROFILE ${txtrst}"
    echo -e "${txtgrn} [SHELL_SCRIPT_PATH] : $SHELL_SCRIPT_PATH ${txtrst}"
fi

process;
echo -e "${txtylw}=======================================${txtrst}"
