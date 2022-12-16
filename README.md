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
* key-iamsojung.pem
### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 
* iamsojung-public-subnet01 (192.168.16.0/26)
* iamsojung-public-subnet02 (192.168.16.64/26)
* iamsojung-private-subnet01 (192.168.16.128/27)
* iamsojung-admin-subnet01 (192.168.16.160/27)

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://web.iamsojung-webservice.o-r.kr




---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : 

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

```
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

REPOSITORY=/home/ubuntu/nextstep
PROJECT_NAME=infra-subway-deploy

function pull() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 저 장 소 PULL 😎 >>${txtrst}"
    cd $REPOSITORY/$PROJECT_NAME/
    git pull step3
}

function build() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 프 로 젝 트 빌 드 💘 >>${txtrst}"
    ./gradlew clean build -x test
}


function moveAndCopyBuild() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 빌 드 파 일 복 사🔥 >>${txtrst}"
    cd $REPOSITORY
    cp $REPOSITORY/$PROJECT_NAME/build/libs/*.jar $REPOSITORY/
    JAR_NAME=$(ls -tr $REPOSITORY/ | grep jar | tail -n 1)
}

function checkPid() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 실 행 중 인 pid 확 인👀 >>${txtrst}"
    CURRENT_PID=$(pgrep -f  *.jar)
    
    echo -e "${txtgrn}  << pid: $CURRENT_PID 👀 >>${txtrst}"
    
    if [ -z "$CURRENT_PID" ]; then
      echo "> 실 행 중 인 것 이 없 습 니 다 ."
    else
      echo "> kill -15 $CURRENT_PID"
    kill -15 $CURRENT_PID
    sleep 5
    fi
}

function deploy() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << 배 포 🏃♂️ >>${txtrst}"
  nohup java -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=prod -jar $REPOSITORY/$JAR_NAME &
  echo -e "${txtylw}----------START APPLICATION ------------${txtrst}"
}

## START FUNCTION

pull;
build;
moveAndCopyBuild;
checkPid;
deploy;
```


