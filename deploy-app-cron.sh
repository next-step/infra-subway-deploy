#!/bin/bash

BRANCH=$1
PROFILE=$2

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
    echo -e "[$(date)] Run Deploy!!!"
    source ./deploy-app.sh ${BRANCH} ${PROFILE}
  fi
}
check_df
