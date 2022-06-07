#!/bin/bash

## 변수 설정

txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple

BRANCH=$1
PROFILE=$2

BASE_PATH="/home/ubuntu/nextstep"
DEPLOY_PATH="/infra-subway-deploy"

function check_input() {
  if [ "$BRANCH" != "main" ]; then
    echo -e "선택하신 $BRANCH은 없는 브랜치입니다."
    exit 0
  fi

  if [[ "$PROFILE" != "local" ]] && [[ "$PROFILE" != "prod" ]]; then
    echo -e "선택하신 $PROFILE 은 없는 PROFILE 입니다."
    exit 0
  fi
}

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ "$master" == "$remote" ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

function pull() {
  echo -e ""
  echo -e "${txtpur}>> Pull Request${txtpur}"
  git pull origin $BRANCH
}

function build() {
  echo -e ""
  echo -e "${txtpur}>> Gradle Build${txtpur}"
  ./gradlew clean build
}

function kill_process() {
  PID=$(lsof -t -i :8080 -s TCP:LISTEN)
  if [[ $PID -gt 0 ]]; then
    echo -e ""
    echo -e "${txtpur}>> Kill $PID ${txtpur}"
    sudo kill $PID
    sleep 5
  fi
}

function deploy() {
  echo -e ""
  echo -e "${txtpur}>> Deploy Application ${txtpur}"
  JAR_PATH=$(find "$DEPLOY_PATH"/build/libs/* -name "*.jar")
  # shellcheck disable=SC2086
  nohup java -jar -Dspring.profiles.active=$PROFILE  "$JAR_PATH" 1> $BASE_PATH/app.log 2>&1 &
}

if [[ $# -eq 2 ]]; then
  ## 파라미터 체크
  check_input;

  echo -e "${txtred}=======================================${txtred}"
  echo -e "${txtylw}  << 배포 스크립트 🧐 >>${txtylw}"
  echo -e "${txtred}=======================================${txtred}"

  cd "$BASE_PATH" || exit

  ## 변경 확인
  check_df;

  ## 저장소 pull
  pull;

  ## gradle build
  build;

  ## 기존 프로세스 종료
  kill_process;

  ## 애플리케이션 배포
  deploy;
else
  echo -e "두개의 입력값이 필요합니다. 😫"
  exit 0
fi

