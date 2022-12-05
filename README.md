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
doorisopen-key.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 192.168.11.0/24

|영역|IP|비고|
|:---:|:---:|:---:|
|public-a|192.168.11.0/26||
|public-c|192.168.11.64/26||
|internal|192.168.11.128/27||
|manage|192.168.11.160/27||

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : 13.125.19.229 (http://doorisopen.kro.kr:8080/)


---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : [https://doorisopen.kro.kr/](https://doorisopen.kro.kr/)

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

스크립트 경로: /home/ubuntu/nextstep/subway.sh

예시
```bash
>> cd /home/ubuntu/nextstep
>> ./subway.sh
==================FUNCTION LIST=====================
1. build
2. start
3. stop
4. status
====================================================
수행할 번호를 입력해주세요: 4
```

스크립트
```bash
#!/bin/bash

BASE_PATH=/home/ubuntu/nextstep
APP_PATH=$BASE_PATH/infra-subway-deploy
LOG_PATH=$BASE_PATH/log/subway.log
APP_NAME=subway

JAVA_OPTION=-Djava.security.egd=file:/dev/./urandom

cd $APP_PATH

## 저장소 pull
function pull() {
  echo -e ""
  echo -e ">> branch를 입력해주세요:"
  read branch
  echo -e ">> input branch: $branch"
  echo -e ">> Pull Request"

  check_diff $branch

  git checkout $branch
  git pull origin $branch
}

function check_diff() {
  git fetch
  master=$(git rev-parse ${1})
  remote=$(git rev-parse origin/${1})
  if [[ $master == $remote ]]; then
    echo -e "[$(date) Noting to do!]"
    exit 1
  fi
}

## gradle build
function build() {
  echo -e ">> Build Start"
  pull
  echo -e ">> Pull Ok"
  ./gradlew clean build
}

function find() {
  ps -ef | grep java | grep ${APP_NAME} | awk '{print $2}'
}

function status() {
  local PID=$(find)
  if [ -n "${PID}" ]; then
    echo -e ">>${APP_NAME}(PID=${PID}) is running"
  else
    echo - ">>${APP_NAME} is stopped"
  fi
}

function start() {
  echo -e ">> App Start";

  echo -e ">> 실행할 profile을 입력해주세요(local, test, prod):"
  read profile
  echo -e ">> input profile: $profile"

  nohup java ${JAVA_OPTION} -Dspring.profiles.active=$profile -jar $APP_PATH/build/libs/subway-0.0.1-SNAPSHOT.jar 1> $LOG_PATH 2>&1 &
}

## 프로세스를 종료하는 명령어
function stop() {
  echo -e ">> App Stop"
  local PID=$(find)
  echo "Stopping ${APP_NAME}..... (PID:${PID})"
  if [[ "${PID}" -lt 3 || -z "${PID}" ]]; then
    echo "${APP_NAME} was not running."
  else
    kill -9 ${PID}
    echo " - Shutdown ...."
  fi
}


FUNCTIONS=("build" "start" "stop" "status")
echo "==================FUNCTION LIST====================="
for i in "${!FUNCTIONS[@]}"
do
  echo "$((i+1)). ${FUNCTIONS[$i]}"
done
echo "===================================================="

echo -n "수행할 번호를 입력해주세요: "
read selectNumber

case $selectNumber in
  "1") build;;
  "2") start;;
  "3") stop;;
  "4") status;;
  *) echo "1 ~ 4까지 입력 가능합니다";;
esac
```

