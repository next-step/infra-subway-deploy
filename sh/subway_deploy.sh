#!/bin/bash

## 변수 설정
PROJECT_PATH=/home/ubuntu/nextstep/infra-subway-deploy
LIBRAY_PATH=/home/ubuntu/nextstep/infra-subway-deploy/build/libs
APP_NAME=subway-0.0.1-SNAPSHOT.jar
BRANCH_NAME=deokmoon


txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 START 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

## 저장소로 이동
function movePath() {
 cd $PROJECT_PATH
 echo -e "MOVE PATH[$PROJECT_PATH]"
}

## 저장소 중복 체크
function check_git_diff() {
git fetch origin

echo  -e "git rev-parse $BRANCH_NAME"
echo  -e "git rev-parse origin/$BRANCH_NAME"

MASTER=$(git rev-parse $BRANCH_NAME)
REMOTE=$(git rev-parse origin/$BRANCH_NAME)

echo -e ""
echo -e ">> Git Diff Check"
echo -e "MASTER[$MASTER]"
echo -e "REMOTE[$REMOTE]"

if [[ $MASTER == $REMOTE ]]; then
  echo -e "[$(date)] Nothing git diff!!! 😫"
  exit 0
fi

echo -e "<< Git Diff Sucess"
}
## 저장소 pull
function pull() {
 echo -e ""
 echo -e ">> GIT Pull Request 🏃♂️ "
   git pull
 echo -e "<< Git Pull Sucess"
}
## 빌드
function build() {
 echo -e ""
 echo -e ">> Build Start 🏃♂️"
  $PROJECT_PATH/gradlew clean build
 echo -e ">> Build Sucess"
}
## 프로세스 종료
function stop() {
 echo -e ""
 echo -e ">> Process Stop 🏃♂️"

 PID=$(pgrep -f $APP_NAME)

 if [ -z $PID ]; then
         echo -e ">> Process Not Exists"
 else
       echo -e  ">> Kill -15 $PID"
        kill -15 $PID
        sleep 6
 fi

 echo -e "<< Process Stop Sucess"
}

## 프로세스 실행
function start() {
 echo -e ""
 echo -e ">> Process ReStart 🏃♂️"
   echo -e "nohup java -jar -Dspring.profiles.active=prod  $LIBRAY_PATH/$APP_NAME 1> $PROJECT_PATH/service.log 2>&1  &"
   nohup java -jar -Dspring.profiles.active=prod $LIBRAY_PATH/$APP_NAME 1> $PROJECT_PATH/service.log 2>&1  &
 echo -e "<< Process ReStart Sucess"
}

## 스크립트 스타트 ###

# 저장소로 이동
movePath

# git diff check
check_git_diff

# git pull
pull

# project build
build

# process kill
stop

# process restart
start

### 스크립트 종료 ###
