<p align="center">
    <img width="200px;" src="https://raw.githubusercontent.com/woowacourse/atdd-subway-admin-frontend/master/images/main_logo.png"/>
</p>
<p align="center">
  <img alt="npm" src="https://img.shields.io/badge/npm-%3E%3D%205.5.0-blue">
  <img alt="node" src="https://img.shields.io/badge/node-%3E%3D%209.3.0-blue">
  <a href="https://edu.nextstep.camp/c/R89PYi5H" alt="nextstep atdd">
    <img alt="Website" src="https://img.shields.io/website?url=https%3A%2F%2Fedu.nextstep.camp%2Fc%2FR89PYi5H">
  </a>
  <img alt="GitHub" src="https://img.shields.io/github/license/next-step/atdd-subway-service">
</p>

<br>

# 인프라공방 샘플 서비스 - 지하철 노선도

<br>

## 🚀 Getting Started

### Install
#### npm 설치
```
cd frontend
npm install
```
> `frontend` 디렉토리에서 수행해야 합니다.

### Usage
#### webpack server 구동
```
npm run dev
```
#### application 구동
```
./gradlew clean build
```
<br>

## 미션

* 미션 진행 후에 아래 질문의 답을 README.md 파일에 작성하여 PR을 보내주세요.

### 0단계 - pem 키 생성하기

1. 서버에 접속을 위한 pem키를 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요   
   업로드 완료했습니다.
2. 업로드한 pem키는 무엇인가요.   
uj-key.pem
### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 
- 192.168.55.0/26 (public 1)
- 192.168.55.64/26 (public 2)
- 192.168.55.128/27 (internal)
- 192.168.55.160/27 (admin)


2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : 	http://uj-subway-infra.kro.kr:8080



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://uj-subway-infra.n-e.kr/

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
```shell


#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

APP_DIRECTORY='./infra-subway-deploy'
BUILD_FILE_NAME='./build/libs/subway-0.0.1-SNAPSHOT.jar'
LOG_FILE_NAME='application.log'
EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

function move_directory() {
cd $APP_DIRECTORY
}

function check_df() {
git fetch
master=$(git rev-parse $BRANCH)
remote=$(git rev-parse origin/$BRANCH)

if [[ $master == $remote ]]; then
echo -e "[$(date)] Nothing to do!!! 😫"
exit 1
fi
}

function pull() {
echo -e ""
echo -e ">>Pull Request 🏃♂️"
git pull
}

function build() {
echo -e ""
echo -e "Gradle Build"
./gradlew clean build
}

function app_stop() {
local PID=$(pgrep -f java)
echo -e ""
echo -e "Stop App"
kill -9 $PID
}

function app_start() {
echo -e ""
echo -e "Start App"
nohup java -jar -Dspring.profiles.active=$PROFILE $BUILD_FILE_NAME 1> $LOG_FILE_NAME 2>&1 &
}

if [[ $# -ne 2 ]]
then
echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e ""
echo -e "${txtgrn} $0 브랜치 이름, 실행환경 ${txtred}{ main | prod }"
echo -e "${txtylw}=======================================${txtrst}"
exit
fi

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

move_directory;
check_df;
pull;
build;
app_stop;
app_start;
```

