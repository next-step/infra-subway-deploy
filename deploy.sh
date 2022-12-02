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
JAR_PATH=$EXECUTION_PATH/build/libs/*

## define function
function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin $BRANCH
}

function run_server() {
	echo "어플리케이션 실행 중..."
	nohup java -jar -Dspring.profiles.active=$PROFILE $JAR_PATH 1> subway.log 2>&1 &
	sleep 5
	CURRENT_PID=$(pidof java)
	echo "PID: ${CURRENT_PID} 어플리케이션이 실행되었습니다. - ${PROFILE}환경"
}

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
	CURRENT_PID=$(pidof java)
	if [ -z $CURRENT_PID ]; then
	  run_server
	  exit 1
	fi
	else
      echo -e "[$(date)] Nothing to do!!! 😫"
      exit 1
  fi
}

function check_param() {
  if [[ $# -ne 2 ]]
  then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e ""
    echo -e "${txtred} 파라미터가 없습니다. 아래와 같이 파라미터를 전달해주세요."
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
  fi
}

## 실행경로 이동
cd $SHELL_SCRIPT_PATH

## check params
check_param $1 $2

## git checkout
echo ""
echo "git branch checkout"
git checkout $BRANCH

## check git diff
echo ""
echo "git branch 변경사항 체크."
check_df

## 저장소 pull
echo ""
echo "저장소 pull"
pull

## gradle build
./gradlew clean build

## 현재 실행중인 프로세스 종료
CURRENT_PID=$(pidof java)

if [ -z $CURRENT_PID ]
then
  echo "실행중인 자바 어플리케이션이 없습니다 java"
else
  echo ">>>> PID: $CURRENT_PID 종료 중..."
  kill -2 $CURRENT_PID
  sleep 20
fi


## 서버 실행
run_server
