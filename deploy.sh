#!/bin/bash
<<<<<<< HEAD

## 변수 설정
BRANCH=$1
PROFILE=$2

=======
## 텍스트 변수 설정
>>>>>>> 9b67a42 (feature: step3 구현)
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

<<<<<<< HEAD

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << DEPLOY >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

function pull() {
  echo -e ">> Getting branch 🏃♂️ "
  git pull origin "$BRANCH"
}

function build() {
  echo -e ">> Building 🏃..."
  ./gradlew clean build -x test
}

function get_pid() {
  echo -e "$(jps | grep "subway" | awk '{print $1}')"
}

function kill_app() {
  local pid="$1"
  if [[ -z $pid ]]; then
    echo -e ">> PID not found 🏃..."
  else
    echo -e ">> Killing PID (PID: $pid) 🏃..."
    kill "$pid"
  fi
}

function start_app() {
  echo -e ">> Starting up (Profile: $PROFILE) 🏃... "
  nohup java -jar \
        -Dspring.profiles.active="$PROFILE" \
        $(find ./* -name "*.jar" | head -n 1) \
        1>/home/ubuntu/subway.log \
        2>&1 \
        &
}

## 저장소 pull
pull;

## gradle build
build;

## 프로세스 pid를 찾는 명령어
PID="$(get_pid)";

## 프로세스를 종료하는 명령어
kill_app "$PID";

## 프로젝트 실행
start_app;
=======
## 스크림트 실행시 전달되는 파라미터

EXECUTION_PATH=${pwd}
SHELL_SCRIPT_PATH=$(dirname "$0")
BRANCH=$1
PROFILE=$2
## 조건 설정
if [[ $# -ne 2 ]]; then
    echo -e "${txtred}사용법: ./deploy.sh <branch> <profile>${txtrst}"
    echo -e "${txtgrn}profile: { test | local | dev | prod }${txtrst}"
    exit 0
else
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}        << 배포 스크립트 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 $BRANCH ${txtred} <$PROFILE> ${txtrst}"
    echo -e "${txtylw}=======================================${txtrst}"
fi
function check_diff() {
    cd "$SHELL_SCRIPT_PATH" || exit 1
    git fetch
    master=$(git rev-parse "$BRANCH")
    remote=$(git rev-parse origin/"$BRANCH")
    if [[ "$master" == "$remote" ]]; then
      echo -e "[$(date)] Nothing to do!!! "
      exit 0
    fi
}
function repository_pull() {
    echo -e "${txtgrn} 저장소 $BRANCH pull 시작... ${txtrst}"
    git stash
    git checkout "$BRANCH"
    git pull
    git stash pop
    echo -e "${txtgrn} 저장소 pull 완료! ${txtrst}"
}
function gradle_build() {
    echo -e "${txtgrn} gradle build 시작... 🐘${txtrst}"
    "$SHELL_SCRIPT_PATH"/gradlew clean build
    echo -e "${txtgrn} gradle build 완료! ${txtrst}"
}
function get_pid() {
    echo -e "${txtgrn} 프로세스 pid 찾기... ${txtrst}"
    pid=$(pgrep -a "java" | grep "subway" | awk '{print $1}')
    echo -e "${txtgrn} 프로세스 pid 찾기 완료! ${txtrst}"
    echo -e "$pid" # for pipeline chaining
}
function kill_process() {
    echo -e "${txtgrn} 프로세스 종료... ${txtrst}"
    if [ -z "$pid" ]; then
        echo -e "${txtred} 프로세스 pid 없음! ${txtrst}"
    else
      kill -9 "$pid"
      echo -e "${txtgrn} 프로세스 종료 요청 완료! ${txtrst}"
    fi
}
function nohup_run() {
    echo -e "${txtgrn} nohup 실행... 프로필: $PROFILE ${txtrst}"
    if [ "$PROFILE" = "local" -o "$PROFILE" = "dev" -o "$PROFILE" = "prod" ]; then
        nohup java -jar -Dspring.profiles.active="$PROFILE" "$SHELL_SCRIPT_PATH"/build/libs/subway-0.0.1-SNAPSHOT.jar  1> logging.log 2>&1 &
        echo -e "${txtgrn} nohup 실행 완료! ${txtrst}"
    else
        echo -e "${txtred} 프로필 오류! ${txtrst}"
        exit 1
    fi
}

check_diff
repository_pull
gradle_build
get_pid
kill_process
get_pid
nohup_run
>>>>>>> 9b67a42 (feature: step3 구현)
