#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

cd /home/ubuntu/infra-subway-deploy
EXECUTION_PATH=$(pwd)
BRANCH=$1
PROFILE=$2
DEPLOY_SH_PATH=${EXECUTION_PATH}/deploy.sh

if [[ $# -ne 2 ]]
then
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << 크론 잡 스크립트 🧐 >>${txtrst}"
  echo -e ""
  echo -e "${txtgrn} $0 ${txtred}{ 브랜치이름 } ${txtylw}{ 프로파일 }"
  echo -e "${txtylw}=======================================${txtrst}"
  exit
fi

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 크론 잡 스크립트 🧐 >>${txtrst}"
echo -e ""
echo -e "${txtgrn} $0 ${txtred}$1 ${txtylw}$2"
echo -e "${txtylw}=======================================${txtrst}"

## branch 변경 체크
function check_diff() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

## 배포 스크립트 실행
function deploy() {
  bash ${DEPLOY_SH_PATH} ${BRANCH} ${PROFILE}
}

check_diff
sleep 5
deploy
