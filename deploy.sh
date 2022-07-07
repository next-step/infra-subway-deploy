#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

EXECUTION_PATH=/home/ubuntu/nextstep/infra-subway-deploy
BRANCH=$1
PROFILE=$2

check_diff() {
  echo -e "${txtylw} 1️⃣  Check diff... ${txtrst}"
  echo -e ""

  git fetch
  changes=$(git diff origin/$BRANCH $BRANCH)

  if [ -z $changes ]; then
    echo -e "${txtgrn} >> [$(date)] There is no difference. ${txtrst}"
    does_exist_diff_from_remote=false
  else
    echo -e "${txtgrn} >> Some changes are identified. New build needed. ${txtrst}"
    does_exist_diff_from_remote=true
  fi

  echo -e ""
}

pull_changes() {
  echo -e "${txtylw} 2️⃣  Pull changes... ${txtrst}"
  echo -e ""

  git pull -r origin $BRANCH

  echo -e ""
}

build() {
  echo -e "${txtylw} 3️⃣  Gradle build... ${txtrst}"
  echo -e ""
  
  ./gradlew clean build

  echo -e ""
}

find_process() {
  echo -e "${txtylw} 4️⃣  Find process... ${txtrst}"
  echo -e ""
  
  jar_file_name=$(basename ./build/libs/*.jar)
  ps_pid=$(pgrep -f $jar_file_name)

  if [ -z "$ps_pid" ]; then
    echo -e "${txtgrn} >> There is no existing process. ${txtrst}"
  else
    echo -e "${txtgrn} >> Find existing process: $ps_pid"
  fi

  echo -e ""
}

kill_process() {
  echo -e "${txtylw} 5️⃣  Kill process $ps_pid... ${txtrst}"
  echo -e ""
  
  sudo kill $ps_pid
  echo -e " >> Successfully killed process. ${txtrst}"

  echo -e ""
}

run_application() {
  echo -e "${txtylw} 6️⃣  Run application... ${txtylw}"
  echo -e ""
  
  nohup java -jar -Dspring.profiles.active=$PROFILE ./build/libs/$jar_file_name 1> ./logs/subway.log 2>&1 &

  echo -e ""
}

deploy() {
  echo -e "${txtpur}================================================="
  echo -e " 🚀 Deploy script started "
  echo -e ""
  echo -e " >> Branch: $BRANCH "
  echo -e " >> Profile: $PROFILE ${txtrst}"
  echo -e ""

  check_diff

  if [ "$does_exist_diff_from_remote" = true ]; then # 변경사항이 존재할 때
    pull_changes
    build
  fi

  find_process

  if [ -n "$ps_pid" ]; then # 기존 프로세스가 존재할 때
    if [ "$does_exist_diff_from_remote" = true ]; then
      kill_process
    else
      echo -e "${txtgrn} >> Running new application is not needed. ${txtrst}"
      exit 0
    fi
  fi

  run_application

  echo -e "${txtpur} >> Successfully deployed. ✅ "
  echo -e "=================================================${txtrst}"
}

if [ $# -ne 2 ] || ([ "$2" != "prod" ] && [ "$2" != "dev" ]); then
    echo -e "${txtrd}================================================="
    echo -e " ⚠️  Invalid argument ⚠️ "
    echo -e ""
    echo -e ">> 1st argument should be branch name: $1"
    echo -e ">> 2nd argument should be profile (prod or dev): $2"
    echo -e "=================================================${txtrst}"
    exit 0
fi

cd $EXECUTION_PATH
deploy

