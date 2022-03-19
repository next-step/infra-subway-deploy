#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

cd ~/infra-subway-deploy

echo -e ">>>>> git pull"
git pull origin step2


echo -e ">>>>> build"
./gradlew clean build

echo -e ">>>>> 파일이동"
cp /home/ubuntu/infra-subway-deploy/build/libs/*.jar ~/


echo -e ">>>>> restart"
PID=$(pgrep -f java)

echo ">>>>>>>> 현재 구동되고 있는 프로세스 ID  $PID"


kill -2 $PID

nohup java -jar -Dspring.profiles.active=prod *.jar