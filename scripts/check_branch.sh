#!/bin/bash

function check_df() {
  cd $ABSOLUTE_PATH/$PROJECT_NAME

  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}