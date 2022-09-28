#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

REPOSITORY=/home/ubuntu/nextstep/infra-subway-deploy
JAR_REPOSITORY=${REPOSITORY}/build/libs
BRANCH=$1
PROFILE=$2


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

## 프로젝트 폴더로 move
## 저장소 pull
## github branch 변경이 있는지 비교
## gradle build
## 프로세스 pid를 찾아서 종료
## 서버 시작

function move() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e ">> MOVE 🏃♂️ "
    cd $REPOSITORY
    echo -e "${txtylw}=======================================${txtrst}"
}

function pull() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e ">> Pull Request 🏃♂️ "
    git pull origin $BRANCH
    echo -e "${txtylw}=======================================${txtrst}"
}

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 1
  fi
}

function build() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e ">> Gradle Clean Build 🏃♂️ "
    ./gradlew clean build
    echo -e "${txtylw}=======================================${txtrst}"
}

function findPidAndKillPid() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e ">> Find Pid And Kill Pid 🏃♂️ "
    CURRENT_PID=$(pgrep -f java)
    echo -e "실행중인 프로세스 ${CURRENT_PID}"
    if [ -z "$CURRENT_PID" ]; then
        echo "> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."
    else
        kill -2 $CURRENT_PID
        sleep 3
    fi
    echo -e "${txtylw}=======================================${txtrst}"
}

function startServer() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e ">> Start Server 🏃♂️ "
    JAR_NAME=$(ls -tr $JAR_REPOSITORY/ | grep jar | tail -n 1)
    echo -e "-Dspring.profiles.active=${PROFILE}"
    echo -e "${JAR_REPOSITORY}${JAR_NAME}"
    nohup java -jar -Dspring.profiles.active=${PROFILE} -Djava.security.egd=file:/dev/./urandom ${JAR_REPOSITORY}/${JAR_NAME} 1> /home/ubuntu/nextstep/infra-subway-deploy.log 2>&1 &
    echo -e "${txtylw}=======================================${txtrst}"
}

move;
pull;
check_df;
build;
findPidAndKillPid;
startServer;