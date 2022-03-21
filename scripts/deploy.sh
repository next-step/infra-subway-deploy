#!/bin/bash

## color echo  function
function print() {
  GREEN="\e[1;32m"
  END_COLOR="\e[0m"
  echo -e "${GREEN}==========================${END_COLOR}"
  echo -e "${GREEN}$1${END_COLOR}"
  echo -e "${GREEN}==========================${END_COLOR}"
}

## 변수 설정
REPOSITORY_DIR=/home/ubuntu/nextstep
APP_NAME=infra-subway-deploy
PID_PATH=$REPOSITORY_DIR/PID

cd $REPOSITORY_DIR/$APP_NAME || exit

## 저장소 pull
print "git pull"
git pull

## gradle build
print "build application"
./gradlew clean build

## 프로세스를 종료하는 명령어
print "check current pid"
if [ -f $PID_PATH ];
then
	PID=$(cat $PID_PATH)
	echo "stop current pid $PID"
	kill -15 $PID
	sleep 10
fi

## 프로세스 시작
print "deploy new application"
nohup java -jar \
        -Dspring.profiles.active=prod \
        $REPOSITORY_DIR/$APP_NAME/build/libs/subway-0.0.1-SNAPSHOT.jar 1> $REPOSITORY_DIR/logs/subway.log 2>&1 & \
        echo $! > $PID_PATH

