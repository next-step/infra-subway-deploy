#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

REPOSITORY_PATH=~/nextstep/infra-subway-deploy
LOG_PATH=${infra-subway-deploy.log}
PROFILES=("local" "prod" "test")


read -p "브랜치 이름을 입력하세요. > " BRANCH
read -p "배포 환경을 입력하세요. > " PROFILE

echo -e "브랜치 이름: ${BRANCH}"
echo -e "배포 환경: ${PROFILE}"

PROFILE_FLAG=false
for profile in "${PROFILES[@]}"
do
  if [[ ${PROFILE} == $profile ]]; then
    PROFILE_FLAG=true
  fi
done

if [[ "$PROFILE_FLAG" = false ]]; then
  echo -e "🤚 올바른 배포 환경을 입력하세요. (${PROFILES[*]})"
  exit 1
fi

function change_dir() {
  echo -e ""
  echo -e ">> ${txtpur} Change directory..."
  cd ${REPOSITORY_PATH}
}

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 1
  fi
}

function pull() {
  echo -e ""
  echo -e ">> ${txtylw} ↪️  Pull..."
  git checkout $BRANCH
  git pull origin $BRANCH
}

function build() {
  echo -e ""
  echo -e ">> ${txtgrn} 🔨 Build start..."
  ./gradlew clean build
}

function stop() {
  echo -e ""
  echo -e "${txtred} >> ❌ Stop exist application..."
  kill -9 `pgrep -f java`
}

function start() {
  echo -e ""
  echo -e "${txtgrn} >> 🟢 Start new application"...
  nohup java -Dspring.profiles.active=${PROFILE} -jar ./build/libs/subway-0.0.1-SNAPSHOT.jar 1> ${LOG_PATH} 2>&1 &
}

change_dir;
check_df;
pull;
build;
stop;
start;