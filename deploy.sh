#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2
FORCE_RESTART=$3

LOG_DATE_HOUR=$(date +%Y%m%d%H)

cd ${SHELL_SCRIPT_PATH}

if [[ "${BRANCH}" == "" || "${PROFILE}" == "" ]]; then
  echo -e "브랜치와 실행할 환경을 입력해주세요"
  exit 0;
fi

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

function pull() {
  echo -e ""
  echo -e "[$(date)] ${txtylw}Pull Request 🏃♂️️${txtrst}"
  git pull origin ${BRANCH}
}

function build() {
  echo -e ""
  echo -e "[$(date)] ${txtylw}Run Build 🏃♂️${txtrst}"
  ./gradlew clean build
}

function kill_process() {
  processId="$(pgrep -f /build/libs/subway)"
  echo -e ""
  if [[ $processId == "" ]]; then
      echo -e "[$(date)] No Process 😫"
      return
  fi

  echo -e "[$(date)] ${txtylw}Find subway process id = ${processId} 🏃♂️${txtrst}"
  kill -9 $processId
}

function run_app() {
  jarName=$(find ./* -name "*jar" | grep /build/libs/subway)
  echo -e ""
  echo -e "[$(date)] ${txtylw}START subway 🏃♂️${txtrst}"
  nohup java -jar -Dspring.profiles.active="$PROFILE" "${jarName}" 1> "./subway_${LOG_DATE_HOUR}.out" 2>&1 &
}

if [[ ${FORCE_RESTART} != "true" ]]; then
  ## 저장소 변경 체크
  check_df
  ## 저장소 pull
  pull
  ## gradle build
  build
fi

## 프로세스를 종료
kill_process
## 앱시작
run_app
