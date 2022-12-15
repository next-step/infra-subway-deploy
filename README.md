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

2. 업로드한 pem키는 무엇인가요.
- KEY-chosundeveloper.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : chosundeveloper-admin 192.168.40.160/27 
         chosundeveloper-public-a 192.168.40.0/26
         chosundeveloper-internal-a 192.168.40.128/27


2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://www.yohan-subway.kro.kr:8080/
- IP : http://3.36.116.114:8080/

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://yohan-subway.kro.kr 

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
/home/ubuntu/deploy.sh
ex) ./deploy.sh 8080 prod

#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray
echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

## 변수 설정
PROJECT_PATH=/home/ubuntu/infra-subway-deploy

function moveDirectory() {
  echo -e "${txtgrn}>> move directory ${txtrst}"
  cd /home/ubuntu/infra-subway-deploy
}

function printParameter() {
  echo -e "${txtgra}"
  echo -e "port = ${port}"
  echo -e "profile = ${profile} [prod,local,test]"
}

function checkGit() {
  echo -e "${txtrst}"
  echo -e "check upstream chosundeveloper"
  currentBranch=$(git rev-parse chosundeveloper)
  echo -e "currentBranch : ${currentBranch}"
  remoteBranch=$(git rev-parse origin/chosundeveloper)
  echo -e "remoteBranch : ${remoteBranch}"
  if [[ "${currentBranch}" == "${remoteBranch}" ]]; then
    echo -e "[$(date)] No Change "
    exit 0
  fi
}

function rebase() {
  echo -e "${txtgrn}"
  echo -e ""
  echo -e "fetch branch chosundeveloper"
  git fetch upstream chosundeveloper
  echo -e "rebase branch chosundeveloper"
  git rebase upstream/chosundeveloper
  git checkout chosundeveloper
}

function build() {
  echo -e ""
  echo -e "${txtgrn}>> BUILD${txtrst}"
  ./gradlew clean build
}

function killProcess() {
  echo -e ""
  echo -e "${txtgrn}>> KILL PROCESS${txtrst}"
  PID=$(pgrep -f subway.*.jar)
  if [ -z "${PID}" ]
  then
    echo "> no running process"
  else
    echo -e "KILL ${PID}"
    kill -9 "${PID}"
  fi
}

function run() {
  echo -e ""
  echo -e "${txtgrn}>> run ${txtrst}"
  nohup java -jar -Dspring.profiles.active=${profile} -Dserver.port=${port} ./build/libs/subway-0.0.1-SNAPSHOT.jar 1> ./deploy.log 2>&1  &
}

if [ -z "$1" ];
then
  port=8080
else
  port=$1
fi

if [ -z "$2" ];
then
  profile=prod
else
  profile=$2
fi

moveDirectory;
printParameter;
checkGit;
rebase;
build;
killProcess;
run;

echo -e "finished"

## 크론탭
00 * * * * ./deploy.sh 8080 prod
