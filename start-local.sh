#!/bin/bash

SCRIPT_PATH=$(dirname "$0")
BRANCH=$1

function checkout() {
  if [ $(git rev-parse --abbrev-ref HEAD) != "$BRANCH" ]; then
    git checkout "$BRANCH"
  fi
}

if [ -n "$BRANCH" ]; then
  checkout
else
  BRANCH=main
  checkout
fi

git pull

"$SCRIPT_PATH"/docker/start.sh local
