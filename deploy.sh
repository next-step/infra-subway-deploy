#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

WEB_ROOT_PATH=$1
BRANCH=$2

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐  >>${txtrst}"
echo -e "${txtgrn}  환경 :${txtrst}"
echo -e "${txtgrn}  - BRANCH: $BRANCH${txtrst}"
echo -e "${txtgrn}  - WEB_ROOT_PATH: $WEB_ROOT_PATH${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

## Branch 다른점 있는지 확인
function check_df(){
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}>> Check Differences 🧐️ ${txtrst}"
  git -C $WEB_ROOT_PATH fetch
  master=$(git -C $WEB_ROOT_PATH rev-parse $BRANCH)
  remote=$(git -C $WEB_ROOT_PATH rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "${txtred}[$(date)] Nothing to do!!! 😫${txtrst}"
    exit 0
  fi
  commit_msg=$(git -C $WEB_ROOT_PATH log origin/step3 --oneline -1)
  echo -e "${txtgrn}>> Has Difference : $commit_msg ✅️ ${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
}

## 저장소 pull
function pull(){
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}>> Pull Request 🏃♂️ ${txtrst}"
  git -C $WEB_ROOT_PATH pull origin $BRANCH
  echo -e "${txtgrn}>> Pull Request END ✅️ ${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
}

## gradle build
function build(){
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}>> Start Build Gradle!! 🛠🛠${txtrst}"
  sh $WEB_ROOT_PATH/gradlew -p $WEB_ROOT_PATH --console=plain clean build
  echo -e "${txtgrn}>> Build Gradle!! END  ✅️ ${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
}

## 프로세스 pid를 찾는 명령어
## 프로세스를 종료하는 명령어
function kill_process(){
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}>> 장비를 정지 합니다!  ❌❌❌ ${txtrst}"
  kill -9 $(lsof -t -i:8080)
  echo -e "${txtgrn}>> 장비 정지 END  ✅ ${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
}

## 새로 빌드한 어플리케이션 시작하는 명령어
function start_app(){
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}>> Start New Application 🍀🍀🍀${txtrst}"
  nohup java -jar -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=prod $(find $WEB_ROOT_PATH/build -name "*jar") 1> $HOME/application.log 2>&1  &
  echo -e "${txtgrn}>> Start New Application Successfully!!  ✅️ ${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
}

#함수 실행
check_df;
pull;
build;
kill_process;
start_app;
