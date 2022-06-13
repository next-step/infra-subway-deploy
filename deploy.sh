#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

BRANCH=$1
PROFILE=$2

function checkDifference() {
  git fetch
  LOCAL=`git rev-parse ${BRANCH}`
  REMOTE=`git rev-parse origin/${BRANCH}`

  if [[ ${LOCAL} == ${REMOTE} ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

function pull() {
    echo -e "${txtpur}=== Step1: Pull Repository [START] ===${txtrst}"
    git pull origin ${BRANCH}
    echo -e "${txtgrn}=== Step1: Pull Repository [COMPLETE] ===${txtrst}"
    echo -e ""
}

function build() {
    echo -e "${txtpur}=== Step2: Build Application [START] ===${txtrst}"
    ./gradlew clean build
    APPLICATION_FILE_PATH=`find ./build/libs* -name "*jar"`
    echo -e "${txtgrn}=== Step2: Build Application [COMPLETE] ===${txtrst}"
    echo -e ""
}

function killOldProcess() {
    echo -e "${txtpur}=== Step3: Kill Old Process [START] ===${txtrst}"
    OLD_PROCESSES_NUMBER=`pgrep -f java -c`
    while [ ${OLD_PROCESSES_NUMBER} != 0 ]; do
        OLD_PROCESS_ID=`pgrep -f java`
        OLD_PROCESS_ID=`echo ${OLD_PROCESS_ID} | cut -d ' ' -f1`
        kill -15 ${OLD_PROCESS_ID}
        OLD_PROCESSES_NUMBER=`pgrep -f java -c`
    done
    echo -e "${txtgrn}=== Step3: Kill Old Process [COMPLETE] ===${txtrst}"
    echo -e ""
}

function startApplication() {
    echo -e "${txtpur}=== Step4: Start Application [START] ===${txtrst}"
    java -jar -Dspring.profiles.active=${PROFILE} ${APPLICATION_FILE_PATH} &
    echo -e "${txtgrn}=== Step4: Start Application [COMPLETE] ===${txtrst}"
    echo -e ""
}

if [ $# -eq 2 ]; then
  checkDifference;
  pull;
  build;
  killOldProcess;
  startApplication;
else
  echo -e "${txtred}ERROR: 브랜치명 또는 스프링 프로파일이 누락되었습니다${txtrst}"
fi
