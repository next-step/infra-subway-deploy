#!/bin/bash

## 변수 설정
PROJECT_DIR=/home/ubuntu/nextstep/infra-subway-deploy


txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtrst}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtred}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtpur}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtgra}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

## 저장소 pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request"
  git pull origin minggul2
}

pull;

## gradle build
${PROJECT_DIR}/gradlew clean build

## 프로세스 pid를 찾는 명령어
PID=$(pidof java)

## 프로세스를 종료하는 명령어
if [ -z "$PID" ]; then
    echo -e "${txtred}  << 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다. >>${txtrst}"
else
    echo "> kill -15 $PID"
    kill -15 $PID
    sleep 5
fi

## 프로세스를 실행하는 명령어
nohup java -jar -Dspring.profiles.active=prod ${PROJECT_DIR}/build/libs/subway-0.0.1-SNAPSHOT.jar 1> subway.log 2>&1 &

## 프로세스 실행 완료
echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 실행 완료 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"