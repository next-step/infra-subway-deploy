#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

BRANCH=$1
PROFILE=$2

function check_df() {
  git fetch

  current=$(git rev-parse --abbrev-ref HEAD)

  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $current == $BRANCH && $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "

  origin=$(git branch -a | grep -w remotes/origin/$BRANCH | xargs)
  local=$(git branch | grep -w $BRANCH | xargs)

  ## origin 존재 여부 확인
  if [[ $origin != "remotes/origin/$BRANCH" ]]; then
    echo -e "[$(date)] $BRANCH branch not found 😫"
    exit 0
  fi

  ## 로컬 브랜치 존재 여부 확인
  if [[ $local != $BRANCH ]]; then
    git checkout -b $BRANCH
  else
    git checkout $BRANCH
  fi

  git pull origin $BRANCH
}

function build() {
  echo -e ""
  echo -e ">> Gradle Build "
  ./gradlew build
}

function kill_process() {
  echo -e ""
  echo -e ">> Kill Java Process"
  killall -w java
}

function start_process() {
  echo -e ""
  echo -e ">> Start Process"
  nohup java -jar -Dspring.profiles.active=$PROFILE build/libs/subway-0.0.1-SNAPSHOT.jar 1> log.txt 2>&1 &
}

if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | local }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

check_df
pull
build
kill_process
start_process
