#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

echo -e "${txtylw}=======================================${txtylw}"
echo -e "${txtrst}  << mysql container 시작 스크립트>>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

# mysql 컨테이너 실행
echo -e "run mysql containner"

DB_NAME=data-subway
DB_PID=$DB_NAME.pid

docker run -d -p 3306:3306 brainbackdoor/data-subway:0.0.1
DID=$(docker ps | grep brainbackdoor/data-subway:0.0.1 | awk '{print$1}')

echo -e "docker id: ${DID}"
echo $DID > $HOME/db/${DB_PID}

docker ps