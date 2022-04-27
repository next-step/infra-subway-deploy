#!/bin/bash
EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1

if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
fi

source ./scripts/checkout.sh ${BRANCH}
source ./scripts/pull.sh ${BRANCH}
source ./scripts/build.sh
source ./scripts/killport.sh
source ./scripts/server.sh