#!/bin/bash

PROFILE=$1
LOGGING_DIR="$HOME/logs"
JAR_PATH="./build/libs/subway-0.0.1-SNAPSHOT.jar"

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

## 조건 설정
if [[ -z $PROFILE ]]
then
    echo -e "${txtylw}===========================================${txtrst}"
    echo -e "${txtgrn} 사용법 : $0 {local | prod}${txtrst}"
    echo -e "${txtylw}===========================================${txtrst}"
    exit
fi

startup() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn} '웹서버를 시작합니다.. ${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
  
  if [[ ! -e $JAR_PATH ]]
  then
    echo -e "jar 파일이 존재하지 않습니다. 빌드를 먼저 진행해주세요."
    exit 1
  fi

  nohup java -jar -Dspring.profiles.active=$PROFILE $JAR_PATH 1> "$LOGGING_DIR/logging.log" 2>&1 &
  echo $! > ./pid.file

  echo ""
  echo ""
}

startup