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
- key-ec2-giraffelim.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역
- giraffelim-public-subnet-2a: 192.168.27.0/26
- giraffelim-public-subnet-2b: 192.168.27.64/26
- giraffelim-private-subnet-2b: 192.168.27.128/27
- giraffelim-admin-subnet-2b: 192.168.27.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요
- URL : http://web.giraffelim.kro.kr:8080/

## 구현 목록
### 망 구성
- [x]  VPC 생성(192.168.27.0/24)
    - [x]  CIDR은 C 클래스(x.x.x.x/24)로 생성, 이 때 다른사람과 겹치지 않게 생성
- [x]  Subnet 생성
    - [x]  외부망으로 사용할 Subnet: 64개씩 2개(AZ를 다르게 구성) → Public
    - [x]  내부망으로 사용할 Subnet: 32개씩 1개 → Internal
    - [x]  관리용으로 사용할 Subnet: 32개씩 1개 → Public
- [x]  Internet Gateway 연결
- [x]  Route Table 생성
- [x]  NAT 게이트웨이 생성
- [x]  Security Group 설정
    - [x]  외부망
        - [x]  전체 대역: 8080포트 오픈
        - [x]  관리망: 22번 포트 오픈
    - [x]  내부망
        - [x]  외부망: 3306 포트 오픈
        - [x]  관리망: 22번 포트 오픈
    - [x]  관리망
        - [x]  자신의 공인 IP: 22번 포트 오픈
- [x]  서버 생성
    - [x]  외부망에 웹 서비스 용도의 EC2 생성
    - [x]  내부망에 데이터베이스 용도의 EC2 생성
    - [x]  관리망에 베스쳔 서버 용도의 EC2 생성
    - [x]  베스쳔 서버에 Session Timeout 600s 설정
    - [x]  베스쳔 서버에 Command 감사 로그 설정
    - [x]  웹 서버에 Session Timeout 600s 설정
    - [x]  웹 서버에 Command 감사 로그 설정
    - [x]  데이터베이스 서버에 Session Timeout 600s 설정
    - [x]  데이터베이스 서버에 Command 감사 로그 설정
### 웹 애플리케이션 배포
- [x]  외부망에 웹 애플리케이션을 배포
- [x]  DNS 설정

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요
- URL : https://web.giraffelim.kro.kr

## 구현 목록
### 운영 환경 구성하기
- [x] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
  - [x] 외부망에 Nginx로 Reverse Proxy 구성
  - [x] Reverse proxy에 TLS 설정
- [x] 운영 데이터베이스 구성하기
### 개발 환경 구성하기
- [x] 설정 파일 나누기
  - [x] Test: Junit/H2
  - [x] Local: mysql(Docker)
  - [x] Prod: 운영 DB
---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
```shell
#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray
PWD=$(pwd)
BRANCH=$1
PROFILE=$2
CHECK=$3

## guide
function help() {
  echo -e "${txtgra}===============================================================${txtrst}"
  echo -e "${txtrst}          << deploy.sh manual🧐 >>                             ${txtrst}"
  echo -e "${txtrst}  argumetns: 1st=branch, 2nd=profile, 3nd=check(true, false)   ${txtrst}"
  echo -e "${txtrst}  !if check=${txtred}true${txtrst} compare branch to origin branch ${txtrst}"
  echo -e "${txtrst}  !if check=${txtred}false${txtrst} always deploy using branch, profile ${txtrst}"
  echo -e "${txtrst}  example: ./deploy.sh step2 prod true(or false)               ${txtrst}"
  echo -e "${txtgra}===============================================================${txtrst}"
}

## check diff
function check_df() {
  git fetch
  MASTER=$(git rev-parse $BRANCH)
  REMOTE=$(git rev-parse origin/$BRANCH)

  if [ $MASTER == $REMOTE ]; then
	  echo -e "[$(date)] Nothing to do!!! 😫"
	  exit 0
  fi;
}

## 배포
function deploy() {
  if [ "$CHECK" == true ]; then
	  check_df
  fi;
  pull;
  build;
  find_running_process;
  kill_running_process;
  run_application;
}

## 저장소 pull
function pull() {
  echo -e ""
  echo -e ">> Pull Request $BRANCH 🏃♂️ "
  git pull origin $BRANCH
}

## gradle build
function build() {
  echo -e ""
  echo -e ">> Gradle Build 🚴♂️"
  $PWD/gradlew clean build
}

## find running process pid
function find_running_process() {
  echo -e ""
  echo -e ">> find exist running subway service process 🧐"
  RUNNING_PROCESS=$(ps -ef | grep subway | grep jar | awk '{print $2}' )
  if [ -n "$RUNNING_PROCESS" ]; then
	  echo -e "find running subway process: ${txtred}$RUNNING_PROCESS${txtrst}"
  else
	  echo -e "no process found ❌"
  fi;
}

## kill running process by pid
function kill_running_process() {
  if [ -n "$RUNNING_PROCESS" ]; then
	  echo -e ""
	  echo -e ">> kill running process ${txtred}$RUNNING_PROCESS 🪡 ${txtrst} "
	  kill -9 $RUNNING_PROCESS
  fi;
}

## run subway application
function run_application() {
  echo -e ""
  echo -e ">> run subway application 🚀"
  nohup java -jar -Dspring.profiles.active=$PROFILE $PWD/build/libs/subway-0.0.1-SNAPSHOT.jar 1> $PWD/subway.log 2>&1 &
}

if [ -n "$BASH" ] && [ -n "$PROFILE" ]; then
	deploy
else
	help
fi;
```

## 구현 목록
- [x] 아래 조건을 만족하는 배포 스크립트 작성하기
    - [x] branch pull
    - [x] gradle build
    - [x] find running process
    - [x] remove running process
    - [x] run application
    - [x] check diff
    - [x] help(사용법)

