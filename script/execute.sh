#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

JAR_NAME='subway.jar'


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << subway start!!! 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

## 프로세스 pid를 찾는 명령어
CURRENT_PID=$(pgrep -f ${JAR_NAME})
echo "> 애플리케이션 pid: $CURRENT_PID"

## 프로세스를 종료하는 명령어
if [ -z "$CURRENT_PID" ]; then
  echo "> 구동중인 애플리케이션 없음"
else
  echo "> kill $CURRENT_PID"
  kill $CURRENT_PID
  sleep 5
fi

mv $JAR_NAME ~/subway/$JAR_NAME

echo "> Jar Name: $JAR_NAME"
nohup java -Djava.security.egd=file:/dev/./urandom -jar -Dspring.profiles.active=prod ./subway/subway.jar 1> ./subway/subway.log 2>&1  &