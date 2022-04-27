#!/bin/bash

BRANCH=$1

function pull() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${BRANCH} 브랜치 작업내용 당겨오기"
  echo -e" ${txtylw}=======================================${txtrst}"

  git pull origin ${BRANCH}
}

pull;