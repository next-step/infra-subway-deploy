#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


# 파라미터 전달 // Y.N 입력받기도 가능하면 좋음
EXECUTION_PATH="/home/ubuntu/nextstep/infra-subway-deploy-mand2" # ~/deploy-prod.sh 에 위치.
echo -e "${txtylw}EXECUTION_PATH $EXECUTION_PATH ${txtrst}"

cd $EXECUTION_PATH
SHELL_SCRIPT_PATH=$(dirname $0)

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

  # 서버에서 직접 수정한 것은 충돌나므로, 다 삭제 + 충돌나기 전에 repo에 push 하는 정책으로.
  git stash -u
  git pull origin $BRANCH
  git stash clear
}

function build() {
  echo -e ""
  echo -e "${txtylw} >>> gradle build <<<${txtrst}"
  $EXECUTION_PATH/gradlew clean build
}


function deploy() {
  echo -e ""
  echo -e "${txtpur} >>> deploy on $BRANCH with $PROFILE START <<<${txtrst}"

  build_file=$(find $SHELL_SCRIPT_PATH/* -name "subway*.jar")
  echo -e "${txtgra} find jar file $build_file ${txtrst}"

  $(nohup java -Dspring.profiles.active=$PROFILE  \
                      -Djava.security.egd=file:/dev/./urandom  \
                      -jar $build_file 1> web-log.txt 2>&1 &)
}

function is_deploy_success() {
  echo -e ""
  echo -e "${txtylw}>>> check deploy success <<<${txtrst}"

  NEW_PID=$(pgrep -f java)

  if [ NEW_PID -eq -1 ]; then
    echo -e "${txtred} DEPLOY FAILED !!!! ${txtrst}"
  else
    echo -e "${txtgrn} DEPLOY SUCCESS !!! [ $NEW_PID ] ${txtrst}"
  fi
}

function find_old_pid() {
  echo -e ""
  echo -e "${txtylw} >>> find OLD PID <<<${txtrst}"
  OLD_PID=$(pgrep -f java)
}

function kill_old_pid() {
  echo -e ""
  echo -e "${txtred} >>> kill OLD PID <<<${txtrst}"

  if [ $OLD_PID -eq -1 ]; then
    echo -e "${txtred} no running pid ${txtrst}"
  else
    kill -2 $OLD_PID
    echo -e "${txtylw} kill running pid [ $OLD_PID ] ${txtrst}"
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
  is_deploy_success
}


process_interface

