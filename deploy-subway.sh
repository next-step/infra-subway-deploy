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
JAR_FILE_NAME=$(find ./* -name "*jar")

ACTIVE_PROFILE=prod
echo ">> 배포할 파일명  ${JAR_NAME}"
echo ">> 실행할 profile = ${ACTIVE_PROFILE}"

## 실행하기
nohup java -jar -Dspring.profiles.active=${ACTIVE_PROFILE} ${JAR_FILE_NAME} &