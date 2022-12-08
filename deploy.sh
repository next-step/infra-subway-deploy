#!/bin/bash

## 변수 설정
REPOSITORY=/home/ubuntu/nextstep/infra-subway-deploy
BUILD_PATH=./build/libs
BRANCH=$1
PROFILE=$2

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << Script 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

function valid_parameter() {
  if [ "$BRANCH" == ""  ]; then
    echo "please write deploy target branch"
    exit 1
  fi
  case "$PROFILE" in
    "prod") ;; "test") ;; "local") ;;
    *) echo "please write deploy target environment"
       exit 1;;
  esac
}

function check_current_branch() {
  echo -e ""
  echo -e ">> Check Current Branch 🏃♂️ "
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  if [ "$current_branch" != "$BRANCH" ]; then # 여기서 비교를 못하는 듯;; (crontab 할 때)
    echo -e "please check current branch and checkout deploy target branch. Current branch -> ${current_branch}"
    exit 1
  fi
  echo -e "current branch -> ${current_branch}"
}

## git branch 변경 사항 체크
function check_branch_df() {
  echo -e ""
  echo -e ">> Check Branch Difference 🏃♂️ "
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 1
  fi
}

## 배포할 브랜치 저장소 pull
function pull_branch() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin deploy
}

## gradle build
function build_application() {
  echo -e ""
  echo -e ">> Gradle build 🏃♂️ "
  ./gradle clean build
}

## 작동중인 어플리케이션 프로세스 pid를 찾는 명령어
function check_exists_process_pid() {
  echo -e ""
  echo -e ">> Check pid and kill pid if exists 🏃♂️ "
  CURRENT_PID=$(pgrep -f java)
  if [ -z "$CURRENT_PID" ]; then
    echo "No exist application."
  else
    echo "Kill exist application"
    kill -9 "$CURRENT_PID"
  fi
}

function run_application() {
  echo -e ""
  echo -e ">> Run application 🏃♂️ "
  JAR_NAME=$(ls ${BUILD_PATH} | grep jar | tail -n 1)
  nohup java -Dspring.profiles.active="${PROFILE}" -Djava.security.egd=file:/dev/./urandom -jar ${BUILD_PATH}/"${JAR_NAME}" 1> application.log 2>&1 &
}

## deploy.sh 파라미터 유효성 검증
valid_parameter;

## 현재 branch 확인
check_current_branch

## branch 변경 유무 확인
check_branch_df;

## remote branch 로컬 반영
pull_branch;

## 어플리케이션 빌드
build_application;

## 실행 중인 어플리케이션 프로세스 종료
check_exists_process_pid;

## 어플리케이션 실행
run_application;