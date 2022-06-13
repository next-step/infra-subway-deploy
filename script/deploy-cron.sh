#!/bin/bash

## 변수 설정
BASE_PATH=/home/ubuntu/nextstep/infra-subway-deploy
BRANCH=$1
PROFILE=$2

## git 저장소 변경 사항 체크
function check_df() {
  echo -e ">> Change Dir ${BASE_PATH} 🏃♂️"
  cd ${BASE_PATH}

  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
    echo -e "[$(date)] There have been changes. Start Deploy!!! 🏃♂️"
    source ${BASE_PATH}/script/deploy-script.sh ${BRANCH} ${PROFILE}
  fi
}

echo -e ">> Start Check Changes 🏃♂️"
check_df
echo -e ">> End Check Changes 🧐 "