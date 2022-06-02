#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

REPO=/home/ubuntu/nextstep/infra-subway-deploy-step3/infra-subway-deploy
SERVICE='subway'
BRANCH=$1

function git_pull(){
  git pull origin ${BRANCH}
  git checkout ${BRANCH}
}

if [ $# -eq 1 ]; then
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}         <<  배포스크립트 >>${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
else
        echo -e "${txtred} >> [ERROR] 브렌치 명을  입력해주세요.(명령어 {Branch명})\n${txtrst}"
  exit 0
fi

# 저장소 pull
echo -e "\n${txtgrn} >> 저장소를 pull 합니다.(Branch=${BRANCH}) \n${txtrst}"
cd ${REPO}
git pull

# gradle build
echo -e "\n${txtgrn} >> 빌드를 시작합니다.(Branch=${BRANCH}) \n${txtrst}"
./gradlew clean build

# 프로세스 pid 찾기
echo -e "\n${txtgrn} >> 현재 실행중인 프로세스를 찾습니다. \n${txtrst}"
ps -ef | grep java

# 프로세스 종료하기
echo -e "\n${txtgrn} >>  실행중인 프로세스를 종료하였습니다. \n${txtrst}"
#kill -2 `pgrep -f java`
killall -9 java

# 실행하기
echo -e "\n${txtgrn} >> 서버를 실행합니다. \n${txtrst}"
nohup java -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=prod -jar ${REPO}/build/libs/subway-0.0.1-SNAPSHOT.jar 1> app.log 2>&1 &

echo -e "\n${txtgrn} >> 처리가 완료되었습니다. \n${txtrst}"
ps -ef | grep java
