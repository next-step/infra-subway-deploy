#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

shutdown() {
  process_id=$(cat ./pid.file)
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn} $process_id 프로세스를 종료합니다.. ${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"

  kill $process_id

  echo ""
  echo ""
}

shutdown