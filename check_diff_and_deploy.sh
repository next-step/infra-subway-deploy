#!/bin/bash

BRANCH=soob-forest

function input() {
        if [[ -n $1 ]]; then
                BRANCH=$1
        fi
        echo -e $BRANCH
}
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
    sh ./deploy.sh
  fi
}
input;
check_df;