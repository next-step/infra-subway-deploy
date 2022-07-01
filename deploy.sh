#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

PROJECT_PATH=/home/ubuntu/nextstep/infra-subway-deploy
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
else
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e "${txtylw}=======================================${txtrst}"
fi

function pull() {
    echo -e ""
    echo -e ">> Pull Request x🏃♂️ "
    git checkout $BRANCH
    git pull
}

function build() {
    echo -e ""
    echo -e ">> Build Gradle🏃♂️ "
    ./gradlew clean build
}

function shutdown_process() {
    echo -e ""
    echo -e ">> Find Process ID🏃♂️ "
    CURRENT_PID=$(pgrep -f ${PROJECT_NAME}.*.jar)
    echo -e "현재 구동중인 애플리케이션 pid  : $CURRENT_PID "

    echo -e ">> 구동 중 애플리케이션 종료"
    if [ $CURRENT_PID  -eq 0 ]; then
      echo -e "현재 구동중이 애플리케이션이 없으므로 종료할게 없습니다.."
    else
      kill -2 $CURRENT_PID
      echo "애플리케이션 종료 완료"
    fi
}
function deploy() {
    echo -e ""
    echo -e ">> Deploy 🥳"
    JAR_NAME=$(find $PROJECT_PATH/build/ -name "subway*.jar")
    echo -e "JAR_NAME : $JAR_NAME"
    nohup java -jar -Dspring.profiles.active=$PROFILE $JAR_NAME > $PROJECT_PATH/subway.log 2>&1 &
    echo -e ""
    echo -e ">> Deploy Success"
}
function start(){
  ## 저장소 pull
  pull;
  ## gradle build
  build;
  ## 프로세스를 종료하는 명령어
  shutdown_process;
  ## 새 애플리케이션 배포
  deploy;
}

start;