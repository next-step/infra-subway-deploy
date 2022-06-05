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
- limwoobin-key.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- IPv4 CIDR : 192.168.10.0/24
- public1 - 192.168.10.0/26
- public2 - 192.168.10.64/26
- private1 - 192.168.10.128/27
- admin1 - 192.168.10.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://13.124.191.168:8080
- DOMAIN :

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://woo.subway-limwoobin.p-e.kr/

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

### deploy.sh

```shell
#!/bin/bash

## 변수 설정

txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green

CONTAINER_NAME=subway

BRANCH=$1
CONTAINER_ID=$(docker container ls -f "name=$CONTAINER_NAME" -q)

function deploy_message() {
echo -e "${txtylw}==============================================="
echo -e "${txtgrn}  << Deploy Start... >>${txtgrn}"
echo -e "${txtylw}==============================================="
}


function pull() {
echo -e ""
echo -e "${BRANCH} Pull Request ..."
git pull origin ${BRANCH}
}

function build() {
echo -e ""
echo -e "${txtpur}>> Build ..."
./gradlew clean build -x test
docker build --build-arg SPRING_PROFILES_ACTIVE=prod -t subway .
}

function down() {
if [ -z $CONTAINER_ID ]; then
echo -e "${txtgrn} 현재 구동중인 서버가 없으므로 종료하지 않습니다."
else
echo -e "${txtgrn}> Container Stop..."
docker stop $CONTAINER_ID

    echo -e "${txtgrn}> Container Remove..."
    docker rm $CONTAINER_ID
    sleep 5
fi
}

function run() {
echo -e " Docker Container Run"
docker run \
-d \
-p 8080:8080 \
--name subway subway \
-v /etc/localtime:/etc/localtime:ro \
-e TZ=Asia/Seoul
}

deploy_message
pull
build
down
run
```


### cron.sh

```shell
#!/bin/bash

BRANCH=$1
DIRECTORY=/home/ubuntu/nextstep/infra-subway-deploy

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  echo "master: $master"
  echo "remote: $remote"


  if [ $master == $remote ]; then
    echo -e "[$(date)] Nothing to do!!!"
    exit 0
  else
    echo -e "[$(date)] Changed !!!"
    source $DIRECTORY/deploy.sh
  fi
}

cd $DIRECTORY

check_df

```