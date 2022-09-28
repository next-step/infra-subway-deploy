BRANCH=$1

run() {
  DIFF=$(/bin/bash check-diff.sh $BRANCH)
  if [ "$DIFF" = true ]; then
    ./gradlew clean build
    /bin/bash subway-service.sh
  fi
}

run
