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
JAR_NAME="subway-0.0.1-SNAPSHOT.jar"

## compare with remote repository
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)
  if [[ $master == $remote ]]; then
    echo -e "${txtred}>> [$(date)] Repository is already up to date.${txtrst}"
    exit 0
  fi
}

## pull origin repository
function pull() {
  echo -e ""
  echo -e "${txtgrn}>> [$(date)] UPDATE SOURCE CODE"
  echo -e "${txtgrn}>> [$(date)] cdm : git pull origin ${BRANCH}${txtst}"
  git pull origin ${BRANCH}
}

## build application
function build() {
  echo -e ""
  echo -e "${txtgrn}>> [$(date)] GRADLE BUILD. ${txtrst}"
  read -p ">> [$(date)] build with tests? (y)es | (n)o. " -n 1 -r
  echo -e ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${txtgrn}>> [$(date)] cmd : ./gradlew clean build${txtrst}"
    ./gradlew clean build
  elif [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${txtgrn}>> [$(date)] cmd : ./gradlew clean build -x test${txtrst}"
    ./gradlew clean build -x test
  else
    build
  fi
}

## terminate existing process
function terminate() {
  echo -e ""
  echo -e "${txtgrn}>> [$(date)] TERMINATE EXISTING PROCESS ${txtrst}"
  PID=$(pgrep -f ${JAR_NAME})
  if [ -z "${PID}" ]; then
    echo -e "${txtred}>> [$(date)] Not fond running ${JAR_NAME} application. ${txtrst}"
  else
    sig_term
    ck_terminate
  fi
}

## check terminate
function ck_terminate() {
  sleep 3
  if [ -z "${PID}" ]; then
    sleep 3
    print_not_term
    if [ -z "${PID}" ]; then
      sleep 3
      print_not_term
      if [ -z "${PID}" ]; then
        sig_kill
        echo -e "${txtred}>> [$(date)] ${JAR_NAME} is forced terminated. ${txtrst}"
      else
        print_term
      fi
    else
      print_term
    fi
  else
    print_term
  fi
}

## sig_term
function sig_term() {
  kill -15 ${PID}
}

## sig_kill
function sig_kill() {
  kill -9 ${PID}
}

## not terminated message
function print_not_term() {
  echo -e "${txtred}>> [$(date)] ${JAR_NAME} is not terminate yet. ${txtrst}"
}

## terminated message
function print_term() {
  echo -e "${txtgrn}>> [$(date)] ${JAR_NAME} is terminated. ${txtst}"
}

## run application
function run() {
  echo -e ""
  echo -e "${txtgrn}>> [$(date)] DEPLOY APPLICATION ${txtst}"
  nohup java -jar -Dserver.port=8080 -Dspring.profiles.active=$PROFILE $EXECUTION_PATH/build/libs/$JAR_NAME 1>infra-subway-deploy-log 2>&1 &
  PID=$(pgrep -f ${JAR_NAME})
  echo -e "${txtgrn}>> [$(date)] (env: ${PROFILE}) APPLICATION IS STARTED  |  PID : ${PID}"
}

## deploy
function deploy() {
  check_df
  pull
  build
  terminate
  run
}

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  <<<<< SCRIPT >>>>>${txtrst}"
if [[ $# -ne 2 ]]; then
  echo -e ""
  echo -e "${txtylw} $1 Enter the branch name of the repository :${txtred}$(git remote show origin | grep 'Fetch URL')"
  echo -e "${txtylw} $2 Enter the environment profile to deploy :${txtred}{ prod | test }"
  echo -e "${txtylw}=======================================${txtrst}"
  check_df
  exit
else
  echo -e ""
  echo -e "${txtgrn} [Branch] : $BRANCH ${txtrst}"
  echo -e "${txtgrn} [Profile] : $PROFILE ${txtrst}"
fi
deploy
echo -e "${txtylw}=======================================${txtrst}"
