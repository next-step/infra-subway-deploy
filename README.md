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
- jiwonkwon-key.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 
vpc : 192.168.12.0/24
jiwonkwon-public-a : 192.168.12.0/26
jiwonkwon-public-b : 192.168.12.64/26
jiwonkwon-private : 192.168.12.128/27
jiwonkwon-bastion : 192.168.12.160/27


2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://jiwonkwon-infra.p-e.kr:8080/
- 공인IP : http://52.78.197.234:8080/



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://jiwonkwon-infra.p-e.kr/

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray
REPOSITORY=/home/ubuntu/nextstep/infra-subway-deploy
JAR_DIRECTORY=/home/ubuntu/nextstep/infra-subway-deploy/build/libs
EXCUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2


## 조건 설정
if [[ $# -ne 2 ]]
then
	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
	echo -e ""
    	echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
	echo -e "${txtylw}=======================================${txtrst}"
	exit
fi

## github branch 변경이 있는 경우만 스크립트 동작
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH > /dev/null 2>&1)
  remote=$(git rev-parse origin $BRANCH > /dev/null 2>&1)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

## 저장소 pull
check_df;
git pull origin $BRANCH

## repository dir로 이동
cd $REPOSITORY

## gradle build
./gradlew clean build

## 프로세스 pid를 찾는 명령어
CUREENT_PID=$(pgrep -f subway.*.jar)
echo "현재 구동 중인 애플리케이션 pid: $CURRENT_PID"


## 프로세스를 종료하는 명령어
if [ -z "$CURRENT_PID" ]; then
    echo "> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."
else
    echo "> kill -15 $CURRENT_PID"
    kill -15 $CURRENT_PID
    sleep 5
fi

## 새 애플리케이션 배포
echo "> 새 애플리케이션 배포"
JAR_NAME=$(ls -tr $JAR_DIRECTORY | grep jar | tail -n 1)
echo "> JAR Name: $JAR_NAME"
nohup java -jar $JAR_NAME 1> out.log 2>&1 &
