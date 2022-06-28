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
- KEY-choiys.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 
  - VPC(choiys-vpc) : 192.168.111.0/24
  - Subnet
    - choiys-public-2a : 192.168.111.0/26
    - choiys-public-2c : 192.168.111.64/26
    - choiys-private-2a : 192.168.111.128/27
    - choiys-bastion-2c : 192.168.111.160/27 

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : 
  - step1 : http://www.choiys-wootech.kro.kr:8080
  - step2 : http://choiys-wootech.kro.kr



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : http://choiys-wootech.kro.kr

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
```shell script
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
JAR_NAME="subway-0.0.1-SNAPSHOT.jar"

## script 실행 시, 조건 설정
echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
if [[ $# -ne 2 ]]
then
    echo -e ""
    echo -e "${txtylw} $1 해당 Repo의 브랜치명을 입력하세요 :${txtred}$(git remote show origin | grep 'Fetch URL')"
    echo -e "${txtylw} $2 해당 Repo를 실행할 구동환경을 입력하세요 :${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
else
    echo -e ""
    echo -e "${txtgrn} [Branch] : $BRANCH ${txtrst}"
    echo -e "${txtgrn} [Profile] : $PROFILE ${txtrst}"
    echo -e "${txtgrn} [SHELL_SCRIPT_PATH] : $SHELL_SCRIPT_PATH ${txtrst}"
fi

## 저장소 변경 사항 확인
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "${txtred}>> [WARN][$(date)] Repository의 변경 사항이 없습니다.${txtrst}"
    exit 0
  fi
    pull
    build
    kill
    deploy
}

## 저장소 pull
function pull() {
  echo -e ""
  echo -e "${txtgrn}>> [INFO][$(date)] 소스코드를 최신 버전으로 갱신합니다. ${txtrst}"
  echo -e "${txtgrn}>> [INFO][$(date)] cmd : git pull origin ${BRANCH}${txtrst}"
  git pull origin ${BRANCH}
}

## gradle test & build
function build(){
  echo -e ""
  echo -e "${txtgrn}>> [INFO][$(date)] 최신버전 어플리케이션을 빌드합니다. ${txtrst}"
  echo -e "${txtgrn}>> [INFO][$(date)] cmd : ./gradlew clean build${txtrst}"
  ./gradlew clean build
}

## 프로세스 pid를 찾는 명령어
function kill(){
  echo -e ""
  PID=$(pgrep -f ${JAR_NAME})

  if [ -z "$PID" ]
    then
      echo -e "${txtred}>> [WARN][$(date)] 실행중인 ${JAR_NAME}이 없습니다. ${txtrst}"
    else
      kill -15 ${PID}
      sleep 5
      echo -e "${txtgrn}>> [INFO][$(date)] 실행중인 ${JAR_NAME}이 종료되었습니다. PID : ${PID} ${txtrst}"
  fi
}


## 어플리케이션 배포
function deploy() {
	echo -e ""
	echo -e "${txtgrn}>> [INFO][$(date)] 어플리케이션을 배포합니다. ${txtrst}"
  nohup java -jar -Dserver.port=8080 -Dspring.profiles.active=$PROFILE $EXECUTION_PATH/build/libs/$JAR_NAME 1> infra-subway-deploy-log 2>&1 &

  PID=$(pgrep -f ${JAR_NAME})
  echo -e "${txtgrn}>> [INFO][$(date)] 어플리케이션이 시작되었습니다. PID : ${PID} ${txtrst}"
}

check_df;
echo -e "${txtylw}=======================================${txtrst}"

```

