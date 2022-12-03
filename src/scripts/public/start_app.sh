#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << subway app 실행하기 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"


# subway app 실행

PROJECT_NAME=subway
PROJECT_DIR=~/infra-subway-deploy
PROJECT_PID=$PROJECT_DIR/${PROJECT_NAME}.pid

# build
if [[ -f $PROJECT_DIR/build/libs/subway-0.0.1-SNAPSHOT.jar ]]
then
        echo "run app"
else
        echo "build app"
        cd $PROJECT_DIR
        ./gradlew clean build
fi

# run
APP_ENV=prod
env_set=$1

if [ $env_st ]
then
        APP_ENV=$env_set
fi

nohup java -jar -Dspring.profiles.active=${APP_ENV} $PROJECT_DIR/build/libs/subway-0.0.1-SNAPSHOT.jar >> $PROJECT_DIR/$PROJECT_NAME.out 2>&1 & echo $! > $PROJECT_DIR/$PROJECT_NAME.pid