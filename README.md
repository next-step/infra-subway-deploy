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
   - KEY-vista0212

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
    - 192.168.6.0/26 : vista-a
    - 192.168.6.64/26 : vista-b
    - 192.168.6.128/27 : vista-c
    - 192.168.6.160/27 : vista-d

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL
    - http://vista0212.kro.kr/



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://vista0212.kro.kr/

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
  - 사용법 : `./script.sh vista0212`
```shell
## script.sh
## 메인 실행 파일
#!/bin/bash

BRANCH=$1

function pull() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${BRANCH} 브랜치 작업내용 당겨오기"
  echo -e" ${txtylw}=======================================${txtrst}"

  git pull origin ${BRANCH}
}

pull;
```
```shell
## checkout.sh
## git checkout 명령어 실행 스크립트
#!/bin/bash

BRANCH=$1

function checkout() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "    ${BRANCH} 브랜치로 checkout 합니다   "
  echo -e "${txtylw}=======================================${txtrst}"

  git checkout ${BRANCH}
}

checkout ${BRANCH}
```
```shell
## pull.sh
## 리모트 브랜치로부터 작업 내용 PULL
#!/bin/bash

BRANCH=$1

function pull() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${BRANCH} 브랜치 작업내용 당겨오기"
  echo -e" ${txtylw}=======================================${txtrst}"

  git pull origin ${BRANCH}
}

pull;
```
```shell
## build.sh
## 빌드 실행하는 스크립트 실행
#!/bin/bash

function build() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "./gradlew clean build 실행"
  echo -e "${txtylw}=======================================${txtrst}"

  ./gradlew clean build
}

build;
```
```shell
## killport.sh
## 서버 실행 전 기존 포트 kill하는 스크립트 실행
#!bin/bash

function killport() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "kill port 8080"
  echo -e "${txtylw}=======================================${txtrst}"

  fuser -k 8080/tcp
}

killport;
```
```shell
## server.sh
## 서버 실행 스크립트
#!/bin/bash

JAR_PATH=$(find ./* -name "*jar")

function server() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "인프라 공방 / 지하철 노선도 서버를 실행합니다."
  echo -e "${txtylw}=======================================${txtrst}"

  echo -e ${JAR_PATH}

  java -jar -Dspring.profiles.active=prod ${JAR_PATH}
}

server;
```