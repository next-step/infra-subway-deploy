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

 - KEY-sangw0804.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- VPC : 192.168.3.0/24
  - 외부망 1 : 192.168.3.0/26
  - 외부망 2 : 192.168.3.64/26
  - 내부망 : 192.168.3.128/27
  - 관리망 : 192.168.3.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : 3.36.63.232:8080 (http://next-sangw0804-infra.kro.kr:8080)

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://next-sangw0804-infra.kro.kr/

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

#### public-a (nginx / jvm 서버)

- start-server.sh
```sh
#!/bin/bash

start_jvm() {
        SERVER_PID=$(ps -ef | grep subway-0.0.1-SNAPSHOT.jar | grep -v grep | awk '{print $2}')

        if [ -n "$SERVER_PID" ]; then
                echo 'server process already exist!'
                exit 0
        fi

        nohup java -jar -Dspring.profiles.active=prod /home/ubuntu/nextstep/infra-subway-deploy/build/libs/subway-0.0.1-SNAPSHOT.jar 1>/home/ubuntu/nextstep/infra-subway-deploy/log.out 2>&1 &
}

validate_jvm() {
        CNT=0
        curl localhost:8080
        while [ $? -ne 0 -a $CNT -le 5 ]
        do
                echo "validation count : $CNT"
                sleep 3
                CNT=$(($CNT + 1))
                curl localhost:8080
        done

        if [ $CNT -eq 6 ]; then
                echo 'jvm process not ready!!'
                exit 1
        fi

        echo 'jvm process ready!!'
}

start_nginx() {
        docker start proxy
}

## 1. jvm process start
start_jvm

## 2. wait until spring started
validate_jvm

## 3. nginx container start
start_nginx
```

- stop-server.sh
```sh
#!/bin/bash

stop_apache() {
        docker stop proxy
}

stop_jvm() {
        SERVER_PID=$(ps -ef | grep subway-0.0.1-SNAPSHOT.jar | grep -v grep | awk '{print $2}')

        if [ -z "$SERVER_PID" ]; then
                echo 'server process already down!'
                exit 0
        fi

        kill -15 $SERVER_PID

        CNT=0
        while [ -n "$(ps -ef | grep subway-0.0.1-SNAPSHOT.jar | grep -v grep | awk '{print $2}')" -a $CNT -le 5 ]
        do
                CNT=$(($CNT + 1))
                sleep 2
        done

        if [ $CNT -eq 6 ]; then
                echo 'fail to stop jvm!!'
                exit 1
        fi

        echo 'server process successfully down!'
}

## 1. nginx apache down
stop_apache

## 2. jvm process down
stop_jvm
```

- rebuild-server.sh
```sh
#!/bin/bash

cd /home/ubuntu/nextstep/infra-subway-deploy
git pull
/home/ubuntu/nextstep/infra-subway-deploy/gradlew clean build
```

- restart-server.sh
```sh
#!/bin/bash

## 1. stop server
sh /home/ubuntu/stop-server.sh

## 2. rebuild jar
ARG1=$1

if [ "$ARG1" = "rebuild" ]; then
        echo "rebuild jar!"
        sh /home/ubuntu/rebuild-server.sh
fi

## 3. start server
sh /home/ubuntu/start-server.sh
```

#### private-db : 내부망 mysql 서버

- start-db.sh
```sh
#!/bin/bas

docker start mysql_subway
```

- stop-db.sh
```sh
#!/bin/bash

docker stop mysql_subway
```

- restart-db.sh
```sh
#!/bin/bash

sh /home/ubuntu/stop-db.sh

sh /home/ubuntu/start-db.sh
```

#### admin : 어드민 서버

- init-service.sh
```sh
#!/bin/bash

# 1. start db
if [ -z "$(ssh ubuntu@private-db docker ps | grep mysql_subway)" ]; then
        ssh ubuntu@private-db /home/ubuntu/start-db.sh
fi


# 2. start nginx & jvm
if [ -z "$(ssh ubuntu@public-a ps -ef | grep subway-0.0.1-SNAPSHOT.jar)" ]; then
        ssh ubuntu@public-a /home/ubuntu/start-server.sh
fi
```

- restart-service.sh
```sh
#!/bin/bash

## 1. nginx & jvm stop
ssh ubuntu@public-a /home/ubuntu/restart-server.sh $1
```

#### 사용법

```
어드민 서버에서 웹서버 재시작
./restart-service.sh

어드민 서버에서 웹서버 현재브랜치 최신 반영 & 재빌드 & 재시작
./restart-service.sh rebuild

서버군 전체 처음 켜졌을때 (start-server / start-db)
./init-service.sh
```
