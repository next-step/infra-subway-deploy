#!/bin/bash

PROJECT_NAME=subway
PROJECT_DIR=~/infra-subway-deploy/

cd $PROJECT_DIR
git fetch

master=$(git rev-parse main)
remote=$(git rev-parse origin/main)

if [[ $master == $remote ]]
then
        echo "$(date) nothing to do"
        exit 0
else
        echo "$(date) pull remote main"
        ~/scripts/pull_app.sh
fi