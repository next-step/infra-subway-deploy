#!/bin/bash

PROJECT_NAME=infra-subway-deploy
REPOSITORY=/home/ubuntu/nextstep/$PROJECT_NAME

BRANCH=$(git branch --show-current)

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do !!! 😫"
    exit 0
  else
    echo -e "> 리모트 브랜치가 변동되었습니다."
    echo -e "> 로컬 브랜치를 업데이트하고, 다시 배포하겠습니다."
    bash $REPOSITORY/scripts/deploy.sh $BRANCH prod
  fi
}

cd $REPOSITORY
check_df;
