#!/bin/bash

BRANCH=$1
PROFILE=$2
SUBWAY_HOME=/home/ubuntu/nextstep/infra-subway-deploy
REMOTE_URL=https://github.com/lakey001/infra-subway-deploy

function check_df() {
  cd ${SUBWAY_HOME}
  git fetch
  master=$(git rev-parse $BRANCH)
  remote_info=$(git ls-remote $REMOTE_URL $BRANCH)
  remote=$(echo ${remote_info} | cut -d " " -f1)
  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
    echo -e "[$(date)] Change Detected!! Run Deploy!!"
    source ./deploy-app.sh ${BRANCH} ${PROFILE}
  fi
}
check_df
