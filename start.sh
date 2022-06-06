#!/bin/bash

## 변수 설정
EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


## 조건 설정
if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

# 저장소 pull
function pull() {
    echo -e ""
    echo -e ">> Pull Request 🏃♂️ "
    if ! [ $BRANCH ]; then
        echo "Enter git branch: "
        read branch
        git pull origin $branch
    else
        git pull origin $BRANCH
    fi
}

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}


### git check_df
echo ""
echo "Task :: check_df"
check_df;
if [ $? = 0 ]; then
  echo -e ""
  echo -e ">> Task Error :: check_df"
  exit 0
fi

### git pull
echo ""
echo "Task :: pull"
pull;
if [ $? = 0 ]; then
    echo -e ""
    echo -e ">> Task Error :: pull"
    exit 0
fi

### gradle build
echo ""
echo "Task :: Gradle"
./gradlew clean build
if [ $? = 0 ]; then
    echo -e ""
    echo -e ">> Task Error :: pull"
    exit 0
fi

## 프로세스 pid 를 찾는 명령어
echo ""
echo "Task :: PS Kill"
PS=`ps -ef | grep ".jar$" | awk '{print $2 }'`
echo "PS Info >> $PS"
kill $PS

### 프로세스 시작
echo ""
echo "Task :: PS Start"
java -jar -Dspring.profiles.active=$PROFILE $EXECUTION_PATH/build/libs/*.jar &
if [ $? = 0 ]; then
    echo -e ""
    echo -e ">> Task Error :: PS Start"
    exit 0
fi
