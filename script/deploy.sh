#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray
REPOSITORY=/home/ubuntu/nextstep/infra-subway-deploy
JAR_DIRECTORY=/home/ubuntu/nextstep/infra-subway-deploy/build/libs
DOCKERFILE_DIRECTORY=/home/ubuntu
EXCUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2


## 조건 설정
if [[ $# -ne 2 ]]
then
	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
	echo -e ""
    	echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
	echo -e "${txtylw}=======================================${txtrst}"
	exit
fi

## github branch 변경이 있는 경우만 스크립트 동작
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH > /dev/null 2>&1)
  remote=$(git rev-parse origin $BRANCH > /dev/null 2>&1)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

## 저장소 pull
check_df;
git pull origin $BRANCH

## repository dir로 이동
cd $REPOSITORY

## gradle build
./gradlew clean build

## 프로세스 pid를 찾는 명령어
CUREENT_PID=$(pgrep -f subway.*.jar)
echo "현재 구동 중인 애플리케이션 pid: $CURRENT_PID"


## 프로세스를 종료하는 명령어
if [ -z "$CURRENT_PID" ]; then
    echo "> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."
else
    echo "> kill -15 $CURRENT_PID"
    kill -15 $CURRENT_PID
    sleep 5
fi

## 새 애플리케이션 배포
echo "> 새 애플리케이션 배포"
JAR_NAME=$(ls -tr $JAR_DIRECTORY | grep jar | tail -n 1)
echo "> JAR Name: $JAR_NAME"
nohup java -jar $JAR_DIRECTORY/$JAR_NAME $PROFILE 1> out.log 2>&1 &

## 도커 실행 및 TLS 설정
cd $DOCKERFILE_DIRECTORY
echo "> reverse-proxy 실행"
sudo docker build -t reverse-proxy:0.0.2 .
sudo docker run -d -p 80:80 -p 443:443 --name proxy reverse-proxy:0.0.2
sudo docker start proxy
