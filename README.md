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
   * KEY-masuldev.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 
  - 외부망
    - ap-northeast-2a: 172.168.0.0/26
    - ap-northeast-2c: 172.168.0.64/26
  - 내부망
     - ap-northeast-2a: 172.168.0.128/27
  - 관리망
     - ap-northeast-2c: 172.168.0.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://ns.masul.dev


---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://ns.masul.dev

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

EXECUTION_PATH=$(pwd)
APP_NAME="subway"
BRANCH=$1
PROFILE=$2

## 변경사항 체크
## git 리비전 조회
function checkChangeDiff() {
  echo -e ""
  echo -e "${txtylw}>> ${txtpur}변경사항 체크중!${txtrst}"
  git fetch
  LOCAL=`git rev-parse $BRANCH`
  REMOTE=`git rev-parse FETCH_HEAD`

  if [[ $LOCAL == $REMOTE ]]; then
    echo -e ""
    echo -e "${txtylw}>> ${txtgrn}변경사항이 없습니다~${txtrst}"
    exit 0
  else
    killApp
    pull
    build
    run
  fi
}

## git pull
function pull() {
  echo -e ""
  echo -e "${txtylw}>> ${txtpur}Pull!${txtrst}"
  git pull origin $BRANCH
}

## gradle build
function build() {
  echo -e ""
  echo -e "${txtylw}>> ${txtpur}빌드 시작!${txtrst}"
  ./gradlew clean build
}

## Application PID 확인
## PID로 Application 종료
function killApp() {
  echo -e ""
  echo -e "${txtylw}>> ${txtred}변경사항을 반영하기 위해 Application을 종료합니다.${txtrst}"
  PID=$(pgrep -fl subway | grep java | awk '{print $1}')
  if [ -z "$PID" ]; then
   echo -e "${txtylw}>> ${txtgra}Application이 실행중이 아닙니다.${txtrst}"
  else
   kill -9 $PID
   sleep 5
   echo -e "${txtylw}>> ${txtgrn}Application (${PID})을 종료했습니다.${txtrst}"
  fi
}

## nohup.out이 아닌 subway.log로 로그를 뽑기 위한 설정 추가
## profile을 유동적으로 변경가능
function run() {
  echo -e ""
  echo -e "${txtylw}>> ${txtpur}Application을 실행합니다.${txtrst}"
  JAR_FILE=`find ./build/* -name "*jar"`
  nohup java -jar -Dspring.profiles.active=$PROFILE $JAR_FILE 1> subway.log 2>&1 &
}


## 조건 설정
## 원하는 기능 => 위치 매개변수가 있다면 자동적으로 할당, 없다면 기본값 할당
## $# => 위치 매개변수의 개수가 저장된다.
## -ne => not equal, -eq => equal (bash script Relational Operators)
if [[ $# -eq 2 ]]; then
    echo -e "${txtylw}====================================================${txtrst}"
    echo -e "${txtgrn}                 << 스크립트 🧐 >>${txtrst}"
    echo -e "${txtred}Branch: $BRANCH | Profile: $PROFILE ${txtrst}"
    echo -e "${txtylw}====================================================${txtrst}"
    checkChangeDiff
    exit
else
    BRANCH="masuldev"
    PROFILE="prod"
    echo -e "${txtylw}====================================================${txtrst}"
    echo -e "${txtgrn}                 << 스크립트 🧐 >>${txtrst}"
    echo -e "${txtred}Branch: $BRANCH (default) | Profile: $PROFILE (default) ${txtrst}"
    echo -e "${txtylw}====================================================${txtrst}"
    checkChangeDiff
    exit
fi
```
