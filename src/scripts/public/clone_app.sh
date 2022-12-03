#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << clone subway app >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"


# clone subway
REPO=https://github.com/Jeongmin94/infra-subway-deploy.git
DIR_NAME=infra-subway-deploy


if [[ -d ~/$DIR_NAME ]]
then
        echo "repository exists"
        exit 0
fi

cd ~
git clone $REPO