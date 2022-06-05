#!/bin/bash

## 변수 설정

txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green

CONTAINER_NAME=subway

BRANCH=$1
CONTAINER_ID=$(docker container ls -f "name=$CONTAINER_NAME" -q)

function deploy_message() {
  echo -e "${txtylw}==============================================="
  echo -e "${txtgrn}  << Deploy Start... >>${txtgrn}"
  echo -e "${txtylw}==============================================="
}


function pull() {
    echo -e ""
    echo -e "${BRANCH} Pull Request ..."
    git pull origin ${BRANCH}
}

function build() {
  echo -e ""
  echo -e "${txtpur}>> Build ..."
  ./gradlew clean build -x test
  docker build --build-arg SPRING_PROFILES_ACTIVE=prod -t subway .
}

function down() {
  if [ -z $CONTAINER_ID ]; then
    echo -e "${txtgrn} 현재 구동중인 서버가 없으므로 종료하지 않습니다."
  else
    echo -e "${txtgrn}> Container Stop..."
    docker stop $CONTAINER_ID

    echo -e "${txtgrn}> Container Remove..."
    docker rm $CONTAINER_ID
    sleep 5
  fi
}

function run() {
    echo -e " Docker Container Run"
    docker run \
    -d \
    -p 8080:8080 \
    --name subway subway \
    -v /etc/localtime:/etc/localtime:ro \
    -e TZ=Asia/Seoul
}

deploy_message
pull
build
down
run