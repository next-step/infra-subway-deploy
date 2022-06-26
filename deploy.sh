#!/bin/bash

## 자주 사용하는 값 변수에 저장
repository=/home/ubuntu/nextstep
project=infra-subway-deploy
current_path=$(pwd)
branch=$1
profile=$2

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

function start() {
    ## 조건 설정
    if [[ $# -ne 3 ]]
    then
        echo -e "${txtylw}=======================================${txtrst}"
        echo -e "${txtgrn}  << 배포 스크립트 실행 ${0} >>${txtrst}"
        echo -e ""
        echo -e "${txtgrn}  << Branch: ${branch}, Profile: ${profile} >> ${txtrst}"
        echo -e "${txtylw}=======================================${txtrst}"
    fi
}

function pull() {
    # cd project path
    cd $repository/$project/

    # git branch pull
    echo -e "${txtgrn} << 현재 위치 ${current_path} >> ${txtrst}"
    echo -e "${txtgrn} << Git Branch Pull >> ${txtrst}"
    git pull
}

function build() {
    # gradle clean build
    echo -e "${txtgrn} << Project Clean Build >> ${txtrst}"
    ./gradlew clean build
}

function validate() {
    ## 프로세스 pid 탐색
    echo -e "${txtgrn} << 현재 동작중인 프로세스 PID 탐색 >> ${txtrst}"
    current_pid=$(pgrep -f ${project}.*.jar)

    ## 프로세스 pid 종료
    if [ -z "$current_pid" ]; then
        echo -e "${txtgrn} << 현재 동작중인 애플리케이션이 없음 >> ${txtrst}"
    else
        echo -e "${txtgrn} << 현재 동작중인 프로세스 PID: $current_pid >> ${txtrst}"
        echo -e "${txtred} << kill -15 $current_pid >> ${txtrst}"
        kill -15 $current_pid
        sleep 5
    fi
}

function deployment() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 프로젝트 배포 >>${txtrst}"
    echo -e "${txtylw}=======================================${txtrst}"

    jar_path=./build/libs
    java -jar -Dspring.profiles.active=prod $jar_path/subway-0.0.1-SNAPSHOT.jar
}

function run() {
    # cd project path
    cd $repository/$project/

    # git branch validation
    git fetch
    master=$(git rev-parse $branch)
    remote=$(git rev-parse origin/$branch)

    echo -e "${txtgrn} << Git Diff Check >> ${txtrst}"
    echo -e "${txtgrn} << master revision: ${master} >> ${txtrst}"
    echo -e "${txtgrn} << remote revision: ${remote} >> ${txtrst}"
    if [[ $master == $remote ]]; then
        echo -e "[$(date +"%Y-%m-%d %T")] Nothingg to do!!!"
        exit 0
    else
        start;
        pull;
        build;
        validate;
        deployment;
    fi
}

run;
