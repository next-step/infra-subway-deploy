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
UPSTREAM=origin

## 조건 설정
if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "😅 USAGE: ${txtgrn} $0 { branch name } ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse $UPSTREAM $BRANCH | sed -n '2 p')
  if [ "$master" = "$remote" ]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
  echo -e "Start pull branch"
}

function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃"
  git pull $UPSTREAM $BRANCH
}

check_df;
pull;


