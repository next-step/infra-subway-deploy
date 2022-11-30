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
업로드 완료했습니다.

2. 업로드한 pem키는 무엇인가요.  
gunkim-key.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- admin(busten) : 192.168.18.128/27
- public1 : 192.168.18.0/26
- public2 : 192.168.18.64/26
- bastion : 192.168.18.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://infra-study.kro.kr:8080/



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://infra-study.kro.kr/

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
```shell
#!/bin/bash

txtrst='\033[1;37m' # White
txtylw='\033[1;33m' # Yellow
txtgrn='\033[1;32m' # Green

PROJECT_PATH='infra-subway-deploy'
BRANCH=$1
PROFILE=$2


function_print() {
  echo -e "${txtylw}>> $1${txtrst}"
}

function_pull() {
  function_print "'$1' Pull Request"
  git pull origin $1
}

# 여기부터 시작
function_print "======================================="
echo -e "${txtgrn}  << 스크립트 시작 🧐 >>${txtrst}"
function_print "======================================="

cd $PROJECT_PATH

function_pull $BRANCH;

function_print "프로젝트 빌드"
./gradlew clean build

CURRENT_PID=$(pidof java)
function_print "현재 구동중인 프로세스 ID : $CURRENT_PID"

"deploy.sh" 49L, 1254C                                                                                                                     1,1           Top

function_pull() {
  function_print "'$1' Pull Request"
  git pull origin $1
}

# 여기부터 시작
function_print "======================================="
echo -e "${txtgrn}  << 스크립트 시작 🧐 >>${txtrst}"
function_print "======================================="

cd $PROJECT_PATH

function_pull $BRANCH;

function_print "프로젝트 빌드"
./gradlew clean build

CURRENT_PID=$(pidof java)
function_print "현재 구동중인 프로세스 ID : $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
  function_print "구동중이지 않아 프로세스를 종료하지 않습니다."
else
  function_print "$CURRENT_PID번 프로세스를 죽입니다."
  kill -9 $CURRENT_PID
  sleep 2
fi

nohup java -jar -Dspring.profiles.active=$PROFILE ./build/libs/subway-0.0.1-SNAPSHOT.jar 1> subway.log 2>&1 &
function_print "프로세스가 실행되었습니다."

function_print "======================================="
echo -e "${txtgrn}  << 스크립트 종료 🧐 >>${txtrst}"
function_print "======================================="
```

