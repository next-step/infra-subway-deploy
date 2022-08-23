#!/bin/bash

#### 변수 설정 ####
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

#EXECUTION_PATH=$(pwd)
EXECUTION_PATH="/home/ubuntu/nextstep/infra-subway-deploy"
BRANCH=main
ACTIVE_PROFILE=prod
JAR_FILE_NAME=""
PID=0

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>>>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"


### 실행환경 초기화
function init_dir_status() {
  echo ""
  echo ".................... EXECUTION_PATH 💡) $EXECUTION_PATH"
  echo ".................... BRANCH TO CHECK DIFF ✅) $BRANCH"

  cd $EXECUTION_PATH
  git checkout $BRANCH
}

### 저장소 확인 / 스크립트 진행여부를 결정
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! BYE! 👋"
    exit 0
  fi
}

### 저장소 pull
function pull() {
  echo -e ""
  echo -e ".................... PULL REQUEST 🏃"
  git pull origin $BRANCH
}

### 새로 빌드
function build_new() {
  ## gradle build
  echo -e ""
  echo -e "....................GRADLE CLEAN BUILD 🛠"
  $EXECUTION_PATH/gradlew clean build
}

### jar파일이름 찾기
function find_jar_name() {
  echo -e ""
  JAR_FILE_NAME=$(find $EXECUTION_PATH/build/* -name "*jar")
  echo ""
  echo "....................FIND JAR FILE NAME 🔎) : $JAR_FILE_NAME "
}

## 종료할 프로세스 pid 찾기
function find_pid() {
  PID=$(pgrep -f ${JAR_FILE_NAME})
  echo ""
  echo "....................FIND PID TO KILL 🔎️) $PID"
#  echo $PID
}

## pid로 프로세스 종료
function kill_old_pid() {
  if [[ $PID -ne 0 ]]; then
    KILL_PID=$PID
    kill -9 $KILL_PID
    echo ""
    echo "....................KILL PID 😵) $KILL_PID"
  fi
}

function deploy() {
  if [[ $JAR_FILE_NAME -ne "" && $PID -ne 0 ]]; then
    echo ""
    echo "....................JAR FILE TO DEPLOY ✅) $JAR_FILE_NAME"
    echo "....................ACTIVE PROFILE ✅) $ACTIVE_PROFILE"
    nohup java -jar -Dspring.profiles.active=${ACTIVE_PROFILE} ${JAR_FILE_NAME} &
  fi
}

## 실행환경 초기화 / 스크립트 진행 여부 확인
init_dir_status;
check_df;

## 변경사항이 있을 때만 실행
pull;
build_new;
find_jar_name;
find_pid_and_kill;
deploy;

###### deploy-subway.sh : END ######

