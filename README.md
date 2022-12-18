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
- cohys7-key.pem

---

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 
  - (외부망-1) cohys7-subnet-public-a : 192.168.10.0/26
  - (외부망-2) cohys7-subnet-public-b : 192.168.10.64/26
  - (내부망) cohys7-subnet-private : 192.168.10.128/27
  - (관리망) cohys7-subnet-manage : 192.168.10.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://www.cohys7-runningmap.o-r.kr:8080/

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : www.cohys7-runningmap.o-r.kr

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
```shell
#!/bin/bash

BRANCH=$1
PHASE=$2
REPOSITORY=/home/ubuntu/nextstep/infra-subway-deploy
JAR_NAME=build/libs/subway-0.0.1-SNAPSHOT.jar

echo "---------------<< Git Pull >>---------------"
cd $REPOSITORY
git fetch
master=$(git rev-parse $BRANCH)
remote=$(git rev-parse origin/$BRANCH)

if [ "$master" == "$remote" ]; then
  echo -e "[$(date)] Nothing to do!!! 😫"
  exit 1
fi

git switch $BRANCH
git pull

echo "---------------<< Stop Application >>---------------"
echo ">> 현재 구동중인 애플리케이션 pid 확인"
CURRENT_PID=$(pgrep -f $JAR_NAME)

echo "$CURRENT_PID"

if [ -z $CURRENT_PID ]; then
    echo ">> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
    echo ">> kill -2 $CURRENT_PID"
    kill -2 $CURRENT_PID
    sleep 5
fi

echo "---------------<< Stop Proxy >>---------------"
docker stop proxy

echo "---------------<< Gradle Build >>---------------"
./gradlew clean build -x test

echo "---------------<< Deploy New Application >>---------------"
JAR_PATH=$REPOSITORY/$JAR_NAME

echo ">> JAR Name: $JAR_PATH"
nohup java -Dspring.profiles.active=$PHASE -Djava.security.egd=file:/dev/./urandom -jar $JAR_PATH 1> spring.log 2>&1 &

echo "---------------<< Restart Proxy >>---------------"
docker start proxy
```

