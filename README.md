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
- KEY-shineoov.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 192.168.77.0/24 (VPC)
    - 외부망1 → 192.168.77.0/26  (ap-northeast-2a)
    - 외부망2 → 192.168.77.64/26 (ap-northeast-2c)
    - 내부망 → 192.168.77.128/27 (ap-northeast-2a)
    - 관리망 → 192.168.77.160/27 (ap-northeast-2b)

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL :  http://shineoov.p-e.kr:8080 ( 54.180.148.112:8080 )


---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://shineoov.p-e.kr/

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

- 실행

  /home/ubuntu/nextstep/infra-subway-deploy/deploy/deploy.sh step3 prod

- 스크립트 파일

```
#!/bin/bash

PROJECT_ROOT=/home/ubuntu/nextstep/infra-subway-deploy
BUILD_FILE_PATH=$PROJECT_ROOT/build/libs
LOG_FILE_PATH=/var/log/web/infra-subway.log

BRANCH=$1
PROFILE=$2

read -p "배포 하시겠습니까? (y:배포) " IS_DEPLOY

if [ -z ${IS_DEPLOY} ] || [ ${IS_DEPLOY} != "y" ]; then
  echo "배포중지"
  exit
fi

function move() {
  cd ${PROJECT_ROOT}
}

function pull() {

  git pull origin ${BRANCH}

  git checkout ${BRANCH}

}

function build() {

  ./gradlew clean build

}

function process_kill() {

  CURRENT_PID=$(pgrep -f subway.*.jar)

  if [ ${CURRENT_PID} != '' ]; then
        echo "PROCESS KILL /  PID = ${CURRENT_PID} "
        kill -15 ${CURRENT_PID}
        sleep 8
  fi
}

function run() {

  JAR_FILE=$(ls -tr $BUILD_FILE_PATH/*.jar | tail -n 1)

  nohup java -jar -Dspring.profiles.active=${PROFILE} $JAR_FILE 1 > $LOG_FILE_PATH 2>&1 &

}

echo "디렉토리 이동 - 1"
move

echo "GIT PULL - 2"
pull

echo "BUILD - 3"
build

echo "PROCESS KILL - 4"
process_kill

echo "RUN! - 5"
run

echo "배포 완료 - 6"
```

