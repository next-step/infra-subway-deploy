#!/bin/bash

## Variables
LOGGING_DIR="$HOME/nextstep/logs"
SCRIPT_DIR="$HOME/nextstep/infra-subway-deploy/scripts"

## Colors
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

add_line_crlf() {
  echo ""
}

permit_authority_scripts() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn} Permit scripts execution for other ${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
  chmod o+x *
}

make_logging_directory() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn} Make logging Directory ${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"

  if [[ ! -d $LOGGING_DIR ]]; then
    mkdir "$LOGGING_DIR"
  fi

  add_line_crlf
}

permit_authority_scripts

make_logging_directory
