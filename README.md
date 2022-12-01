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
- epicarts-key.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 10.0.0.0/24

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- 공인IP : 43.200.34.194
- URL : http://43.200.34.194:8080
- DOMAIN : http://www.epicarts.o-r.kr:8080

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://www.epicarts.o-r.kr

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
```sh
#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2
JAR_PATH=$EXECUTION_PATH/build/libs/*

## define function
function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin $BRANCH
}

function run_server() {
	echo "어플리케이션 실행 중..."
	nohup java -jar -Dspring.profiles.active=$PROFILE $JAR_PATH 1> subway.log 2>&1 &
	sleep 5
	CURRENT_PID=$(pidof java)
	echo "PID: ${CURRENT_PID} 어플리케이션이 실행되었습니다. - ${PROFILE}환경"
}

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
	CURRENT_PID=$(pidof java)
	if [ -z $CURRENT_PID ]; then
	  run_server
	  exit 1
	fi
	else
      echo -e "[$(date)] Nothing to do!!! 😫"
      exit 1
  fi
}

function check_param() {
  if [[ $# -ne 2 ]]
  then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e ""
    echo -e "${txtred} 파라미터가 없습니다. 아래와 같이 파라미터를 전달해주세요."
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
  fi
}

## 실행경로 이동
cd $SHELL_SCRIPT_PATH

## check params
check_param $1 $2

## git checkout
echo ""
echo "git branch checkout"
git checkout $BRANCH

## check git diff
echo ""
echo "git branch 변경사항 체크."
check_df

## 저장소 pull
echo ""
echo "저장소 pull"
pull

## gradle build
./gradlew clean build

## 현재 실행중인 프로세스 종료
CURRENT_PID=$(pidof java)

if [ -z $CURRENT_PID ]
then
  echo "실행중인 자바 어플리케이션이 없습니다 java"
else
  echo ">>>> PID: $CURRENT_PID 종료 중..."
  kill -2 $CURRENT_PID
  sleep 20
fi


## 서버 실행
run_server
```

