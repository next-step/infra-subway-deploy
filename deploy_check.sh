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

## 조건 설정
if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    echo "git branch 입력: "
    read branch
    echo "git branch: $branch"
fi

cd ~/nextstep/infra-subway-deploy/

## 저장소 pull
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH > /dev/null 2>&1)
  remote=$(git rev-parse origin $BRANCH > /dev/null 2>&1)

  res=0
  if [[ $master == $remote ]]; then
    res=0
  else
    res=1
  fi

  echo ${res}
}

function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin $branch
}

if [[ $(check_df) == 1 ]]; then
  echo "========git pull start========"
  pull
else
  echo -e "[$(date)] Nothing to do!!! 😫"
  exit 0
fi

## gradle build
echo "========build========"
# ./gradlew clean build

## 프로세스 pid를 찾는 명령어
echo "========find pid========"
pid=`ps -aux|grep java|grep subway|awk '{print $2}'`
echo "pid is : $pid"

## 프로세스를 종료하는 명령어
if [[ ! -z "$pid" ]]; then
  echo "========kill pid $pid========"
  kill -2 $pid
fi

## 어플리케이션 시작
echo "========start application========"
echo `java -Dserver.port=8000 -Dspring.profiles.active=prod -Djava.security.egd=file:/dev/./urandom -jar ./build/libs/subway-0.0.1-SNAPSHOT.jar &`
exit 1
