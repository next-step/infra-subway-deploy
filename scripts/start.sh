#!/bin/bash

PROFILE=$1
JAR_PATH_FILENAME=$2
LOGGING_DIR="$HOME/nextstep/logs"

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

## 조건 설정
if [[ -z $PROFILE ]]; then
  echo -e "${txtylw}===========================================${txtrst}"
  echo -e "${txtgrn} Usage : $0 {local | prod} {ex) ./build/libs/subway-0.0.1-SNAPSHOT.jar}${txtrst}"
  echo -e "${txtylw}===========================================${txtrst}"
  exit
fi

add_line_crlf() {
  echo ""
}

startup() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn} Starting WebServer ${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"

  if [[ ! -e $JAR_PATH_FILENAME ]]; then
    echo -e "Not find jar file. First, build the application."
    exit 1
  fi

  nohup java -jar -Dspring.profiles.active="$PROFILE" "$JAR_PATH_FILENAME" 1>"$LOGGING_DIR/application.log" 2>&1 &
  echo $! >../pid.file

  add_line_crlf
}

startup
