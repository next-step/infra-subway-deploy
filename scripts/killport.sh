#!bin/bash

function killport() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "kill port 8080"
  echo -e "${txtylw}=======================================${txtrst}"

  fuser -k 8080/tcp
}

killport;