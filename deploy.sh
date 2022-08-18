#!/bin/bash
## 텍스트 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

## 스크림트 실행시 전달되는 파라미터

EXECUTION_PATH=${pwd}
SHELL_SCRIPT_PATH=$(dirname "$0")
BRANCH=$1
PROFILE=$2

## 스크립트용 변수 설정
process_term_check_count=0

## 조건 설정
if [[ $# -ne 2 ]]; then
    echo -e "${txtred}사용법: ./deploy.sh <branch> <profile>${txtrst}"
    echo -e "${txtgrn}profile: { local | dev | prod }${txtrst}"
    exit 0
else
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}        << 배포 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 $BRANCH ${txtred} <$PROFILE> ${txtrst}"
    echo -e "${txtylw}=======================================${txtrst}"
fi

function repository_pull() {
    echo -e "${txtgrn} 저장소 $BRANCH pull 시작... 📥${txtrst}"
    git stash
    git checkout "$BRANCH"
    git pull
    git stash pop
    echo -e "${txtgrn} 저장소 pull 완료! 🌈${txtrst}"
}

function gradle_build() {
    echo -e "${txtgrn} gradle build 시작... 🐘${txtrst}"
    "$SHELL_SCRIPT_PATH"/gradlew clean build
    echo -e "${txtgrn} gradle build 완료! 🐣${txtrst}"
}

function get_pid() {
    echo -e "${txtgrn} 프로세스 pid 찾기... 🔍${txtrst}"
    pid=$(pgrep -a "java" | grep "subway" | awk '{print $1}')
    echo -e "${txtgrn} 프로세스 pid 찾기 완료! 🔍${txtrst}"
    echo -e "$pid" # for pipeline chaining
}

function kill_process() {
    echo -e "${txtgrn} 프로세스 종료... 🔌${txtrst}"
    if [ -z "$pid" ]; then
        echo -e "${txtred} 프로세스 pid 없음! 🤔${txtrst}"
    else
      kill -9 "$pid"
      echo -e "${txtgrn} 프로세스 종료 요청 완료! 😀${txtrst}"
    fi
}

function check_process_terminated() {
    echo -e "${txtgrn} 프로세스 종료 확인... 🔍${txtrst}"
    if [ -z "$pid" ]; then
        echo -e "${txtgrn} 프로세스 종료 확인 완료! 🔍${txtrst}"
    else
        echo -e "${txtred} 프로세스 종료 확인 실패! ⚠️${txtrst}"
        if [ $process_term_check_count -gt 10 ]; then
            echo -e "${txtred} 프로세스 종료 확인 실패 횟수 초과! ⚠️${txtrst}"
            exit 1
        else
            sleep 3
            process_term_check_count=$((process_term_check_count++))
            check_process_terminated
        fi
    fi
}

function nohup_run() {
    echo -e "${txtgrn} nohup 실행... 프로필: $PROFILE 🎬${txtrst}"
    if [ "$PROFILE" = "local" -o "$PROFILE" = "dev" -o "$PROFILE" = "prod" ]; then
        nohup java -jar -Dspring.profiles.active="$PROFILE" "$SHELL_SCRIPT_PATH"/build/libs/subway-0.0.1-SNAPSHOT.jar  1> logging.log 2>&1 &
        echo -e "${txtgrn} nohup 실행 완료! 🐣${txtrst}"
    else
        echo -e "${txtred} 프로필 오류! 🫣${txtrst}"
        exit 1
    fi
}

function check_diff() {
    git fetch
    master=$(git rev-parse "$BRANCH")
    remote=$(git rev-parse origin/"$BRANCH")

    if [[ $master == "$remote" ]]; then
      echo -e "[$(date)] Nothing to do!!! 🥳"
      exit 0
    fi
}

check_diff
repository_pull
gradle_build
get_pid
kill_process
get_pid
check_process_terminated
nohup_run
