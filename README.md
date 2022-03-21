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

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 
192.168.23.0/26
192.168.23.64/26
192.168.23.128/27
192.168.23.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://3.35.216.201:8080

3. 베스천 서버에 접속을 위한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요
infra-workshop-3 에 KEY-yunhalee05.pem의 이름으로 업로드 하였습니다!

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : http://yunha-infra-subway.o-r.kr

---

### [추가] 배포 스크립트 작성하기


1. 작성한 배포 스크립트를 공유해주세요.
#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

PROJECT_NAME=infra-subway-deploy
BRANCH="$1"
CASE="$2"
SLACK_MESSAGE="Deployed New App Successfully!"
SLACK_URL="https://app.slack.com/"

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

function check_df() {
  git fetch 
  master=$(git rev-parse $BRANCH > /dev/null 2>&1)
  remote=$(git rev-parse origin $BRANCH > /dev/null 2>&1)
  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

## 저장소 pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin yunhalee05
}

## 프로세스 pid를 찾는 명령어
function findProcess() {
  CURRENT_PID=$(pgrep -f java.*.jar)
  echo -e ""
  echo -e ">> Current pid 📡 : $CURRENT_PID"
}

## 프로세스를 종료하는 명령어
function killProcess() {
  if [ -z "$CURRENT_PID" ]; then
    echo -e ">> There's no running app."
  else
    echo -e ">> Kill Process 🪓"
    kill -15 $CURRENT_PID
    sleep 5
  fi
}

## gradle build
function gradleBuild() {
  echo -e ">> Build Gradle... ⌛️"
  ./gradlew clean build
}

## 새 어플리케이션 배포 
function deployNewApp() {
  JAR_FILE=$(./build/libs/subway-0.0.1-SNAPSHOT.jar)
  echo -e ">>"
  nohup java -jar -Dspring.profiles.active=prod &
}

function send_slack() {
  curl -X POST --data "payload={\"text\": \"${SLACK_MESSAGE}\"}" ${SLACK_URL}

}

function deploy(){
  cd $PROJECT_NAME
  pull;
  findProcess;
  killProcess;
  gradleBuild;
  deployNewApp; 
  send_slack;
}

check_df;

case $CASE in
  -f) deploy; exit 0;;
esac

echo -e  ">> ${txtred} Are you sure to deploy new APP 🤔? ${txtrst} [Y/N] "
read react 
case $react in
  [Yy]* ) deploy; exit 0;;
esac


2. cronjob 설정을 공유해주세요.
45 5 * * 5 /home/ubuntu/deploy.sh
