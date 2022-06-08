#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

EXECUTION_PATH=$(pwd)
BRANCH=$1
PROFILE=$2
PID=0
JAR_PATH=""

## 조건 설정
if [ $# -ne 2 ]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 배포 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 배포 스크립트 시작 😄 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

findProcessId() {
  echo -e ""
  echo -e "${txtgrn}>> Find PID ⌛ ${txtrst}"
  PID=$(psgrep -f subway)
}

shutDownProcess() {
  echo -e ""
  echo -e "${txtred}>> KILL PID ${PID} 🚫 ${txtrst}"
  kill -2 "${PID}"
}

pull() {
  echo -e ""
  echo -e "${txtgrn}>> Pull Request ✅ ${txtrst}"
  git pull origin "${BRANCH}"
}

build() {
  echo -e ""
  echo -e "${txtgrn}>> Gradle Clean & Build 🔄 ${txtrst}"
  ./gradlew clean build
}

findJarPath() {
  JAR_PATH=$(find "${EXECUTION_PATH}"/build/libs/* -name "*.jar")
}

deploy() {
  findJarPath;
  echo -e ""
  echo -e "${txtgrn}>> Deploy ${txtrst}"
  java -jar -Dspring.profiles.active="${PROFILE}" "${JAR_PATH}"
}

## 저장소 pull
pull;

## gradle build
build;

## 프로세스 pid 를 찾는 명령어
findProcessId;

## 프로세스를 종료하는 명령어
shutDownProcess;

## 배포
deploy;

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 배포 스크립트 종료 😄 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"