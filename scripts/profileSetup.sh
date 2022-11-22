#!/bin/bash

SCRIPT_PATH=$(dirname "$0")

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << Set up Shell >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"


HISTTIMEFORMAT="%F %T -- "    ## history 명령 결과에 시간값 추가
export HISTTIMEFORMAT
export TMOUT=600              ## 세션 타임아웃 설정

source $SCRIPT_PATH/ps1Setup.sh
source $SCRIPT_PATH/loggerSetup.sh
source $SCRIPT_PATH/aliasSetup.sh

if [[ ! -e ~/.profile ]]; then
        touch ~/.profile
fi

echo $(pwd)/setProfile.sh | sudo tee -a  ~/.profile
