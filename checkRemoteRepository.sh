#!/bin/bash


BRANCH='jhsong2580'

#원격 repository, 현재 commit id 비교
function check_df() {
  cd /home/ubuntu/service/infra-subway-deploy
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
    /home/ubuntu/service/infra-subway-deploy/deploy.sh
  fi
}

check_df