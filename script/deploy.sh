#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

function change_dir(){
  echo -e ""
  echo -e ">> change directory 🏃♂️ "

  cd "$HOME/nextstep/infra-subway-deploy" || exit 1
}

## git branch
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 1
  fi
}

## git pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin master
}

## gradle build
function build(){
  echo -e ""
  echo -e ">> gradle build 🏃♂️ "
  ./gradlew --debug clean build
}

function kill_ps(){
  echo -e ""
  echo -e ">> kill process 🏃♂️ "

  kill -2 $(pgrep -f java)
}

function run(){
  echo -e ""
  echo -e ">> run spring boot 🏃♂️ "
  nohup java -Dspring.profiles.active="$PROFILE" -jar build/libs/subway-0.0.1-SNAPSHOT.jar &
}

## 스크립트 시작
if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtpur}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtpur}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtpur}"
    exit
fi

change_dir;
check_df;
pull;
build;
kill_ps;
run;