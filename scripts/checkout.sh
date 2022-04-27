#!/bin/bash

BRANCH=$1

function checkout() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "    ${BRANCH} 브랜치로 checkout 합니다   "
  echo -e "${txtylw}=======================================${txtrst}"

  git checkout ${BRANCH}
}

checkout ${BRANCH}