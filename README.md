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

2. 업로드한 pem키는 무엇인가요. : KEY-cylee9409.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 192.168.37.0/24

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://43.200.253.185:8080/
- URL(DNS) : http://cylee9409-subway.o-r.kr:8080/


---

### 2단계 - 배포하기
#### 요구사항 작성하기
#### 운영환경 구성하기
- 웹 어플리케이션 앞단에 Reverse proxy 구성
    - 외부망에 Nginx로 Reverse Proxy 구성
    -  Reverse Proxy 에 TLS 설정
- 운영 DB 구성하기
#### 개발환경 구성하기
- 설정 파일 나누기
    - JUnit : h2, Local : docker(mysql), Prod : 운영 DB를 사용하도록 설정

1. TLS가 적용된 URL을 알려주세요

- URL : https://cylee9409-subway.o-r.kr

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

파일명 : /home/ubuntu/nextstep/infra-subway-deploy/start_service.sh

#!/bin/bash

# variable
PROJECT_PATH=/home/ubuntu/nextstep/infra-subway-deploy
ENV=prod
BRANCH=master

TODAY=$(date)
YYYYMMDD=$(date "+%Y%m%d")
CURRENT_TIME=$(date "+%Y%m%d %H:%M:%S")

check_df() {
        git fetch
        master=$(git rev-parse $BRANCH)
        remote=$(git rev-parse origin/$BRANCH)
        if [ $master =  $remote ]; then
                echo -e "[${TODAY}] Nothing to do"
                exit 0;
        fi
}

git_pull() {
        echo "===>> move to project path"
        cd ${PROJECT_PATH}
        pwd
        echo "==========================\n"

        CURRENT_BRANCH="$(git branch | awk '{print $2}')"
        echo "===> current branch : ${CURRENT_BRANCH}\n"

        echo "===> check difference"
        check_df

        echo "===> git pull"
        git pull
        echo "==========================\n"

}

build() {
        echo "===> project build"
        ./gradlew clean build
        JAR_NAME="$(find . -name "*SNAPSHOT.jar" | awk '{print $1}')"
}

activate_service() {
        echo "===> activate jar"
        echo "===> nohup java -jar -Dspring.profiles.active=${ENV} ${JAR_NAME} 1> subway_service_${YYYYMMDD}.log 2>&1 &"
        nohup java -jar -Dspring.profiles.active=${ENV} ${JAR_NAME} 1> subway_service_${YYYYMMDD}.log 2>&1 &
        echo "===> log file Name [subway_service_${YYYYMMDD}.log]"
}

terminate_service() {
        echo "===> stop service"
        PID="$(ps -ef | grep java | grep ${JAR_NAME} | awk '{print $2}')"

        if [ -z ${PID} ];
        then
                echo "===> No process"

        else
                echo "===> kill process ${PID}"
                kill -9 ${PID}
        fi
}

# PROCESS

echo ${CURRENT_TIME}
git_pull

build

terminate_service

activate_service

