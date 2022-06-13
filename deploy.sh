#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

PROFILE_LIST=("prod" "local")
WROKING_DIR="/Users/kimbyounghee/study/nextStep/infra-subway-deploy"

function check_profile() {
  if [ "prod" != $1 ] && [ "local" != $1 ]
  then
      echo -e "${txtred} $1은 존재하지 않습니다."
      exit
  fi
}


function check_branch() {
  git fetch
  git ls-remote --exit-code --heads origin $1
  if [ $? -ne 0 ]
  then
      echo -e "${txtred}해당 브랜치가 존재하지 않습니다.${txtrst}"
      exit 0
  fi
}

function check_df() {
  master=$(git rev-parse $1)
  remote=$(git rev-parse origin/$1)

  if [[ $master == $remote ]]; then
    echo -e "${txtred} [$(date)] 이미 최신 버전으로 배포할 수 없습니다.! 😫"
    exit 0
  fi

  git pull origin $1
}

function build_project() {
    echo -e "빌드시작 🏃🏃"
    ./gradlew clean build
    echo -e "🏃🏃 빌드 완료"
}

function process_kill() {
    FIND_PID="$(pgrep -f subway)";

    if ! [ $FIND_PID == "" ];
    then
      kill -9 $FIND_PID
    fi
}

function reStartServer() {
  process_kill
  jarName=$(find . -name "subway*.jar")
  echo -e "서버 재 시작"
  nohup java -jar ${jarName} --java.security.egd=file:/dev/./urandom --server.port=8080 --spring.profiles.active=${PROFILE} > out.txt 2>&1
}

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

cd ${WROKING_DIR}
read -p "배포할 환경을 입력 하세요(prod or local): " PROFILE
check_profile ${PROFILE}

read -p "배포할 브랜치를 입력 하세요: " BRACNH
check_branch ${BRACNH}
check_df ${BRACNH}

git checkout ${BRACNH}
build_project
reStartServer
