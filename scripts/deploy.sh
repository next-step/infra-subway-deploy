#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

PROJECT_PATH='/home/ubuntu/infra-subway-deploy'
JAR_PATH=${PROJECT_PATH}/build/libs
JAR=$(cd ${JAR_PATH} && find ./* -name "*jar" | cut -c 3-)
JAR_PID=$(ps -ef | grep $JAR | grep -v grep | awk '{print $2}')
LOG_FILE='home/ubuntu/infra-subway-deploy/subway.log'
BRANCH=step3



## 저장소 변경 체크
## 변경이 있다면 pull
## 현재 프로세스 종료
## 프로세스 빌드
## 프로세스 시작
## 로그 기록

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    return 0
  fi
  return 1
}

function pull() {
  cd ${PROJECT_PATH} && git pull
}

function stop_process() {
  if [ -z "$JAR_PID" ]; then
    echo "프로세스가 실행중이지 않습니다."
  else
    echo "$JAR의 프로세스를 종료합니다. (PID = $JAR_PID)"
    kill $JAR_PID
  fi
}

function build() {
  cd ${PROJECT_PATH} && ./gradlew clean build
}

function start_process() {
  nohup java -jar -Dspring.profiles.active=prod $JAR_PATH/$JAR 1> $LOG_FILE 2>&1
}

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  Deploy Start                         ${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

check_df
if [[ $? -eq 0 ]]; then
  echo -e "[$(date)] 변경된 내용이 없으므로 배포를 중지합니다."
  exit 0
fi

echo -e "[$(date)] 업데이트 내용이 있습니다. 🤩 배포를 시작합니다."
pull

stop_process
build
start_process
tail -f $LOG_FILE

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  🛠 정상적으로 배포가 됐습니다.              ${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"



