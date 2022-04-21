#!/bin/bash

PROJECT_ROOT=/home/ubuntu/nextstep/infra-subway-deploy
BUILD_FILE_PATH=$PROJECT_ROOT/build/libs
LOG_FILE_PATH=/var/log/web/infra-subway.log

BRANCH=$1
PROFILE=$2

read -p "배포 하시겠습니까? (y:배포) " IS_DEPLOY

if [ -z ${IS_DEPLOY} ] || [ ${IS_DEPLOY} != "y" ]; then
  echo "배포중지"
  exit
fi

function move() {
  cd ${PROJECT_ROOT}
}

function pull() {

  git pull origin ${BRANCH}

  git checkout ${BRANCH}

}

function build() {

  ./gradlew clean build

}

function process_kill() {

  CURRENT_PID=$(pgrep -f subway.*.jar)

  if [ ${CURRENT_PID} != '' ]; then
        echo "PROCESS KILL /  PID = ${CURRENT_PID} "
        kill -15 ${CURRENT_PID}
        sleep 8
  fi
}

function run() {

  JAR_FILE=$(ls -tr $BUILD_FILE_PATH/*.jar | tail -n 1)

  nohup java -jar -Dspring.profiles.active=${PROFILE} $JAR_FILE 1 > $LOG_FILE_PATH 2>&1 &

}

echo "디렉토리 이동 - 1"
move

echo "GIT PULL - 2"
pull

echo "BUILD - 3"
build

echo "PROCESS KILL - 4"
process_kill

echo "RUN! - 5"
run

echo "배포 완료 - 6"
