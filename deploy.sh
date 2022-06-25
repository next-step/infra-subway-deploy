#!/bin/bash

## 변수 설정

BRANCH=$1
PROFILE=$2
ARG_COUNT=$#

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

function validation() {
  if [[ ARG_COUNT -ne 2 ]]
  then
      echo -e "${txtylw}=======================================${txtrst}"
      echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
      echo -e ""
      echo -e "${txtgrn} $0 브랜치이름 [step3] ${txtred}{ local | prod }"
      echo -e "${txtylw}=======================================${txtrst}"
      exit
  fi
}


function pull() {
    echo "> pull origin ${BRANCH}"
    git pull origin $BRANCH
}

function build() {
    echo "> 빌드 시작"
    ./gradlew clean build
    JAR_NAME=$(basename -- build/libs/*.jar)
    echo "> jar name = ${JAR_NAME}"
}

function kill_pid() {
    pid=$(pgrep -f ${JAR_NAME})

    if [[ -z "${pid}" ]]
    then
      echo "> 현재 구동중인 애플리케이션이 없습니다."
    else
      echo "kill -15 ${pid}"
      kill -15 ${pid}
      sleep 5
    fi
}

function run() {
    echo "> 애플리케이션 실행"
    nohup java -jar -Dspring.profiles.active=${PROFILE} build/libs/${JAR_NAME} > nohup.out 2>&1 &

}

function check_df() {
    git fetch
    master=$(git rev-parse ${BRANCH})
    remote=$(git rev-parse origin ${BRANCH})

    if [[ $master == $remote ]]; then
      echo -e "[$(date)] Nothing to do!!! 😫"
      exit 0
    else
  	  pull
  	  build
  	  kill_pid
  	  run
    fi
}

validation
check_df
