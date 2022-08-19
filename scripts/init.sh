#!/bin/bash

## 변수 설정
LOGGING_DIR="$HOME/logs"

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

make_logging_dir() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn} logging 디렉토리 생성 ${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
  
  if [[ ! -d $LOGGING_DIR ]]
  then
    mkdir $LOGGING_DIR
  fi

  echo ""
  echo ""
}

make_logging_dir