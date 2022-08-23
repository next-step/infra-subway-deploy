#!/bin/bash
## 텍스트 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

## 스크림트 실행시 전달되는 파라미터

EXECUTION_PATH=$(pwd) # 현재 디렉토리
SHELL_SCRIPT_PATH=$(dirname "$0") # root 디렉토리 => .jar 파일을 찾기 위해 root 디렉토리 설정
BRANCH=$1 # 첫 번째 파라미터
PROFILE=$2 # 두 번째 파라미터

## 쉘 스크립트 조건 설정(파라미터 포함)
if [[ $# -ne 2 ]]; then
  echo -e "${txtred}--------------------------------------${txtrst}"
  echo -e "${txtred}사용법: ./deploy.sh <branch> <profile>${txtrst}"
  echo -e "${txtgrn}profile: { test | local | prod }${txtrst}"
  echo -e "${txtred}--------------------------------------${txtrst}"
  exit 0
else
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}        << 배포 스크립트 시작>>${txtrst}"
  echo -e ""
  echo -e "${txtgrn} $0 $BRANCH ${txtred} <$PROFILE> ${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
fi

function profile_check(){
  if [ "$PROFILE" = "test" -o "$PROFILE" = "local" -o "$PROFILE" = "dev" -o "$PROFILE" = "prod" ]; then
    echo -e "${txtgrn} $PROFILE 환경으로 진행 ${txtrst}"
  else
    echo -e "${txtred} 프로필 입력 오류! { test | local | prod } 이 프로필 중 하나를 입력해주세요. ${txtrst}"
    exit 1 # 오류코드 1 = 프로필 입력 오류
  fi
}
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
  git checkout "$BRANCH"
  git pull
}
function gradle_rebuild() {
  echo -e "${txtgrn} gradle clean & build 시작... ${txtrst}"
  $EXECUTION_PATH/gradlew clean build
}
function find_pid_of_older_version_app() {
  echo -e "${txtgrn} 진행 중인 자바 애플리케이션 찾기... ${txtrst}"
  pid=`ps -ef | grep java | grep subway | grep -v "bash -c" | awk '{print $2}'`
}
function check_and_kill_older_version_app() {
  echo -e "${txtgrn} 종료할 프로세스 찾기 ... ${txtrst}"
  if [ -z "$pid" ]; then
    echo -e "${txtred} Nothing java process exists ${txtrst}"
  else
    kill -9 "$pid"
    echo -e "${txtgrn} 프로세스 종료 완료! ${txtrst}"
  fi
}
function nohup_execute_application() {
  echo -e "${txtgrn} nohup execute_application: $PROFILE ${txtrst}"
  nohup java -jar -Dspring.profiles.active="$PROFILE" "$SHELL_SCRIPT_PATH"/build/libs/subway-0.0.1-SNAPSHOT.jar  1> log.txt 2>&1 &
}

profile_check
check_diff
repository_pull
gradle_rebuild
find_pid_of_older_version_app
check_and_kill_older_version_app
nohup_execute_application