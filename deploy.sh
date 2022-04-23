#!/bin/bash
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
REPOSITORY=/home/ubuntu/nextstep
PROJECT_DIR_NAME=infra-subway-deploy
PROJECT_NAME=subway

function check_df() {
  echo -e ""
  echo -e "<< Git Repo에서 Fetch 된 내용이 있는지 Check하기 >>"
  echo -e ""
  echo -e "${txtgrn}> step1: Repository로 이동${txtrst}"
  echo -e ""
  cd $REPOSITORY/$PROJECT_DIR_NAME
  echo -e ""
  echo -e "${txtgrn}> step2: Fetch 할 내용이 있는지 확인${txtrst}"
  echo -e ""
  git fetch
  master=$(git rev-parse $BRANCH > /dev/null 2>&1)
  remote=$(git rev-parse origin/$BRANCH > /dev/null 2>&1)

  if [[ $master == $remote ]]; then
    echo -e "${txtylw}>> [$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

## 저장소 pull
function pull() {
  echo -e ""
  echo -e "<< Git Repo에서 Pull 받기 >>"
  echo -e ""
  echo -e "${txtgrn}> step1: Repository로 이동${txtrst}"
  echo -e ""
  cd $REPOSITORY/$PROJECT_DIR_NAME

  echo -e "${txtgrn}> step2: Git Pull 백엔드 프로젝트${txtrst}"
  echo -e ""
  git pull
}

## gradle build
function build() {
  echo -e ""
  echo -e "<< 프로젝트 Build 하기 >>"
  echo -e ""
  echo -e "${txtgrn}> step1: Repository로 이동${txtrst}"
  cd $REPOSITORY/$PROJECT_DIR_NAME
  echo -e ""
  echo -e "${txtgrn}> step2: 백엔드 프로젝트 Build 시작${txtrst}"
  echo -e ""
  ./gradlew build
}

function copy_to_jar() {
  echo -e ""
  echo -e "<< 프로젝트 Jar 파일 옮기기 >>"
  echo -e ""
  echo -e "${txtgrn}> step1: 기본 디렉토리로 이동( -> $REPOSITORY )${txtrst}"
  cd $REPOSITORY
  echo -e ""

  echo "${txtgrn}> step2: Build 파일 복사${txtrst}"
  echo -e ""
  cp $REPOSITORY/$PROJECT_DIR_NAME/build/libs/*.jar $REPOSITORY/
}

## 프로세스 pid를 찾는 명령어
## 프로세스를 종료하는 명령어
function check_running_process() {
  echo -e ""
  echo -e "<< 이미 구동중인 Application을 체크하고 있다면 종료하기 >>"
  echo -e ""
  echo -e "${txtgrn}> step1: 현재 구동중인 애플리케이션 pid 확인${txtrst}"
  echo -e ""
  CURRENT_PID=$(pgrep -f $PROJECT_NAME)

  echo -e "${txtgrn}>> 현재 구동 중인 애플리케이션 pid: $CURRENT_PID${txtrst}"
  echo -e ""

  if [ -z $CURRENT_PID ]; then
      echo -e "${txtgrn}>> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다.${txtrst}"
      echo -e ""

  else
      echo -e "${txtgrn}>> kill -15 $CURRENT_PID${txtrst}"
      kill -15 $CURRENT_PID
      sleep 5

      CURRENT_PID2=$(pgrep -f $PROJECT_NAME)
      if [ -z $CURRENT_PID2 ]; then
          echo -e "${txtgrn}>> 정상종료되었습니다.${txtrst}"
          echo -e ""
      else
          echo -e "${txtred}>> 강제 종료합니다.${txtrst}"
          echo -e ""
          kill -9 $CURRENT_PID2
          sleep 5
      fi
  fi
}

function deploy_new_app() {
  echo -e ""
  echo -e "<< 새 애플리케이션 배포하기 >>"
  echo -e ""

  echo -e "${txtgrn}> step1: 새 애플리케이션 배포${txtrst}"
  echo -e ""
  cd $REPOSITORY
  JAR_NAME=$(ls $REPOSITORY/ | grep $PROJECT_NAME | tail -n 1)
  echo -e "${txtgrn}>> JAR Path/Name: $REPOSITORY/$JAR_NAME ${txtrst}"
  nohup java -jar -Dspring.profiles.active=$PROFILE $REPOSITORY/$JAR_NAME 1> appplication-log 2>&1 &
}



if [[ $# -ne 2 ]]
  then
      echo -e "${txtylw}=======================================${txtrst}"
      echo -e "${txtgrn}  << 실행 스크립트를 다시 입력해주세요. 🧐 >>${txtrst}"
      echo -e ""
      echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }${txtrst}"
      echo -e "${txtylw}=======================================${txtrst}"
      exit
fi

check_df;
pull;
build;
copy_to_jar;
check_running_process;
deploy_new_app;
