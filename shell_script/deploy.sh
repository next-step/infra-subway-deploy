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
    echo -e "[$(date)] 이미 최신버전이에요!"
    exit 0
  fi

  echo -e "[$(date)] 배포할 내용이 있어요! 잠시만 기다려주세요!"
  git pull

  echo -e "git pull 에 성공하였어요."
}

## gradle build
## 프로세스 pid를 찾는 명령어
## 프로세스를 종료하는 명령어
## ...

check_diff;