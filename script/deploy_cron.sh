#!/bin/bash

BRANCH=$1
PROFILE=$2
BASE_DIR=/home/ubuntu/nextstep/infra-subway-deploy/script

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
    else
      echo "Something Changes Detected Deploy Start"
      source ${BASE_DIR}/deploy.sh ${BRANCH} ${PROFILE}
  fi

  echo "cron script $0"
  check_df
}
