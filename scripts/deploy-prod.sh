#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


## 저장소 pull
## gradle build
## 프로세스 pid를 찾는 명령어
## 프로세스를 종료하는 명령어
## ...


# 파라미터 전달 // Y.N 입력받기도 가능하면 좋음

SHELL_SCRIPT_PATH=$(dirname $0)
EXECUTION_PATH=$(dirname $(pwd)) # ~/scripts/deploy-prod.sh 위치라서 실제 실행위치 (~) 찾기위함.

#ROOT_PATH=$(dirname ${SHELL_SCRIPT_PATH})
#echo -e "${txtylw}ROOT_PATH $ROOT_PATH}${txtrst}"

echo -e "${txtylw}EXECUTION_PATH EXECUTION_PATH}${txtrst}"

BRANCH=$1
PROFILE=$2
OLD_PID=-1

## 조건 설정
if [[ $# -ne 2 ]]
then
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
  echo -e ""
  echo -e "${txtgrn} $0 $BRANCH ${txtred} { prod | dev }"
  echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

function check_df() {
  git remote update

  checkout_branch

  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin $BRANCH
}

function build() {
  echo -e ""
  echo -e "${txtylw} >>> gradle build <<<${txtrst}"
  $EXECUTION_PATH/gradlew clean build
}


function deploy() {
  echo -e ""
  echo -e "${txtpur} >>> deploy on $BRANCH with $PROFILE START <<<${txtrst}"
  echo -e "${txtgra} find jar file${txtrst}"

  BUILD_file=$(find $EXECUTION_PATH/* -name "subway*.jar")

  nohub java -Dspring.profiles.active=${PROFILE} \
  -Djava.security.egd=file:/dev/./urandom \
  -jar ${BUILD_file} 1> web-log.txt 2>&1 &
}

function find_old_pid() {
  echo -e ""
  echo -e "${txtylw} >>> find OLD PID<<<${txtrst}"
  OLD_PID=$(pgrep -f java)
}

function kill_old_pid() {
  echo -e ""
  echo -e "${txtred} >>> kill OLD PID<<<${txtrst}"

  if [ $OLD_PID -eq -1 ]; then
    echo -e "${txtylw} >>> no running pid <<<${txtrst}"
  else
    kill -2 $OLD_PID
    echo -e "${txtylw} >>> kill running pid ${$OLD_PID} <<<${txtrst}"
  fi
}

function check_profile() {
  echo -e ""
  echo -e "${txtylw} >>> check profile <<<${txtrst}"

  if [ "$PROFILE" = "prod" -o "$PROFILE" = "dev" ]; then
    echo -e "${txtgrn} >>> profile = $PROFILE <<<${txtrst}"
  else
    echo -e "${txtred} >>> profile error! <<<${txtrst}"
    exit 1
  fi
}

function checkout_branch() {
  local_branch=$(git branch | grep $BRANCH)

  if [[ -z $local_branch ]]; then
    echo -e "${txtylw} branch doesn't exist in local ! get branch from origin ${txtrst}"
    git checkout -b $BRANCH origin/$BRANCH
  else
    git checkout $BRANCH
  fi
}

# deploy process 묶음
function process_interface() {
  check_profile

  check_df
  pull
  build

  find_old_pid
  kill_old_pid

  deploy
}


process_interface
