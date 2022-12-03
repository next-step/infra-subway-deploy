#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

echo -e "${txtylw}=======================================${txtylw}"
echo -e "${txtrst}  << nginx container 시작 스크립트>>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

# nginx 컨테이너 실행
echo -e "run nginx containner"

PROCESS_NAME=proxy
PROCESS_PID=$PROCESS_NAME.pid
VER=$1

docker run -d -p 80:80 -p 443:443 $VER
PID=$(docker ps | grep $VER | awk '{print$1}')

echo -e "nginx id: ${PID}"
echo $PID > $HOME/dockerfile/${PROCESS_PID}

docker ps