#!/bin/bash

#### 변수 설정 ####

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"


## 일단 함수 없이 저장소 pull - test
echo -e ""
echo -e ">> Pull Request 🏃♂️ "
git checkout feature/week1-step3
git pull origin feature/week1-step3


## gradle build
echo -e ">> gradle clean build"
./gradlew clean build

echo -e ">> find jar name"
JAR_FILE_NAME=$(find ./build/* -name "*jar")

ACTIVE_PROFILE=prod
echo ">> 배포할 파일명  $JAR_FILE_NAME"
echo ">> 실행할 profile = ${ACTIVE_PROFILE}"

## 프로세스 pid 찾기
PID=$(pgrep -f ${JAR_FILE_NAME})

echo ">> 종료할 프로세스 pid = $PID"


## pid로 프로세스 종료
echo ">> 프로세스 종료하기"
kill -2 ${PID}


echo ">> $JAR_FILE_NAME 서비스 $ACTIVE_PROFILE 로 배포"
## 실행하기
nohup java -jar -Dspring.profiles.active=${ACTIVE_PROFILE} ${JAR_FILE_NAME} &
