```sh
#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

REPOSITORY=/home/ubuntu/ljh0326/infra-subway-deploy
JAR_REPOSITORY=${REPOSITORY}/build/libs
BRANCH=$1
PROFILE=$2

## 조건 설정
if [ $# -ne 2 ]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

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
    if [ -z $CURRENT_PID ]; then
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
    nohup java -jar -Dspring.profiles.active=${PROFILE} ${JAR_REPOSITORY}/${JAR_NAME} 1> infra-prod 2>&1 &
    echo -e "${txtylw}=======================================${txtrst}"
}

move;
pull;
build;
findPidAndKillPid;
startServer;
```