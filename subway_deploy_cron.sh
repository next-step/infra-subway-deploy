#!/bin/bash

BRANCH=${1}
PROFILE=${2}

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)
  echo -e "master = ${master}, reomote = ${remote}"
  if [ $master == $remote ]
  then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
    source /home/ubuntu/nextstep/infra-subway-deploy/deploy.sh ${BRANCH} ${PROFILE}
  fi
}
cd /home/ubuntu/nextstep/infra-subway-deploy
echo -e "BRANCH is ${1}"
check_df