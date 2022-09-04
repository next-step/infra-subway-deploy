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

if [[ $# -ne 2 ]]
then
  echo -e "2개의 매개변수를 입력해주세요. 1번째 매개변수: git branch name, 2번째
 매개변수: profile"
  exit
fi

echo -e "${txtylw}======================================="
echo -e "${txtgrn}  << 배포 시작! 🧐 >>"
echo -e ""
echo -e "${txtgrn} 스크립트 : ${txtred} $0"
echo -e "${txtgrn} 브랜치 : ${txtred} $1"
echo -e "${txtgrn} 프로필 : ${txtred} $2"
echo -e "${txtgrn} 프로젝트 경로 : ${txtred} $EXECUTION_PATH"
echo -e "${txtylw}=======================================${txtrst}"

## diff
function check_diff() {
  git fetch
  git checkout $BRANCH
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)
  echo $master
  echo $remote

  if [[ $master == $remote ]]
  then
    echo -e "[$(date)] 최신버전이네요! 나머지 스크립트를 실행할게요!"
  else
    echo -e "[$(date)] 최신버전이 아니에요. 최신버전으로 업데이트 할게요. 잠시만 기다려주세요!"
    pull
    echo -e "[$(date)] 성공적으로 git pull 을 마쳤어요! 배포 스크립트를 다시 실행해보세요!"
    exit
  fi
}

# git pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull
}

## gradle build
function gradle_build() {
  echo -e ""
  echo -e ">> Gradle Build 🏃♂️ "
  echo -e "[$(date)] 프로젝트를 gradle 로 빌드할게요."
  ./gradlew clean build
  echo -e "[$(date)] Gradle build 를 완료했어요!"
}

## java 프로세스 pid를 찾기
function get_java_pid() {
  echo -e ""
  echo -e ">> Get java PID 🏃♂️ "
  PID=`pgrep -f java`
  echo -e "Java PID: $PID"
}

## jar 의 이름 찾기
function get_jar_name() {
  echo -e ""
  echo -e ">> Get jar name 🏃♂️ "
  JAR_NAME=$(find build/* -name "*jar")
  echo -e "Jar name: $JAR_NAME"
}

## 프로세스를 종료하는 명령어

# 테스트

check_diff;
# gradle_build;
get_java_pid;