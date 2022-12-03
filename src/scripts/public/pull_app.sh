#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << pull subway app >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

PROJECT_NAME=subway
PROJECT_DIR=~/infra-subway-deploy

cd $PROJECT_DIR

echo "pull remote repository"
git pull origin main