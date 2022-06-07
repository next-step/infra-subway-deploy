#!/bin/bash
## 변수 설정
txtrst=‘\033[1;37m’ # White
txtred=‘\033[1;31m’ # Red
txtylw=‘\033[1;33m’ # Yellow
txtpur=‘\033[1;35m’ # Purple
txtgrn=‘\033[1;32m’ # Green
txtgra=‘\033[1;30m’ # Gray
JAR_FILE_PATH=/home/ubuntu/nextstep/infra-subway-deploy/build/libs/subway-0.0.1-SNAPSHOT.jar
DSPRING=prod
echo -e “${txtylw}=======================================${txtrst}”
echo -e “${txtgrn}  << 스크립트 :단안경을_쓴_얼굴: >>${txtrst}”
echo -e “${txtylw}=======================================${txtrst}”
## 저장소 pull
function pull() {
  echo -e “”
  echo -e “>> Pull Request :주자::남성_기호: ”
  git pull
  git submodule update
}
## gradle build
function gradelBuild() {
    /home/ubuntu/nextstep/infra-subway-deploy/gradlew clean build
}
## 프로세스 pid를 찾아서 존재한다면 종료
function killApp() {
    APP_PID=`ps -ef | grep “.jar$” -m 1 | awk ‘{print $2}’`
    echo “APP_PID >> $APP_PID”
    sudo kill -2 $APP_PID
}
## 프로세스 실행
function startApp() {
    echo “APP_START”
    sudo nohup java -jar -Dspring.profiles.active=$DSPRING $JAR_FILE_PATH 1> /home/ubuntu/nextstep/log/server_logfile 2>&1  &
}
cd /home/ubuntu/nextstep/infra-subway-deploy
pull;
gradelBuild;
killApp;
startApp;
