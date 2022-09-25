#!/bin/bash

BRANCH=$1

git fetch

MASTER=$(git rev-parse $BRANCH)
REMOTE=$(git rev-parse origin/$BRANCH)

if [ "$MASTER" == "$REMOTE" ]; then
        exit 1
fi

echo -e "[$(date)] A change has been detected."
git pull origin $BRANCH
git checkout $BRANCH

./gradlew clean build
/bin/bash subway-service.sh
