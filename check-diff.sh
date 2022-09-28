#!/bin/bash

BRANCH=$1

diff() {
  git fetch

  MASTER=$(git rev-parse $BRANCH)
  REMOTE=$(git rev-parse origin/$BRANCH)

  if [ "$MASTER" != "$REMOTE" ]; then
    echo "[$(date)] Changed."
    git pull origin $BRANCH
    echo true
  else
    echo false
  fi
}

diff
