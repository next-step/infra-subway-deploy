#!/bin/bash

EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
PROFILE=$1

## 조건 설정
if [[ $# -ne 1 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

## gradle build
$SHELL_SCRIPT_PATH/gradlew clean build

## 프로세스 pid를 찾는 명령어
PID=`pgrep -f $SHELL_SCRIPT_PATH/build/libs/*.jar`

## 프로세스를 종료하는 명령어
if [[ -n "$PID" ]]; then
  kill -9 $PID
fi

## 프로세스를 실행!
JARFILE=`find $SHELL_SCRIPT_PATH/build/libs/* -name "*jar"`
nohup java -jar -Dspring.profiles.active=$PROFILE $JARFILE 1> ~/subway.log 2>&1 &
