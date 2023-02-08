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

if [[ $# -ne 2 ]]; then
  echo -e "${txtylw}======================================${txtrst}"
  echo -e "${txtgrn} << 스크립트 🧐 >>${txtrst}"
  echo -e ""
  echo -e "${txtgrn} $0 브랜치 이름 ${txtred}{ prod | dev }"
  echo -e "${txtgrn}======================================${txtrst}"
  exit
fi

function pull() {
        echo -e ""
        echo -e ">> Pull Request 🏃♂️ "
}

pull;

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  echo "$master"
  echo "$remote"

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!!  😫"
    exit 1
  fi
}