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

1. 서버에 접속을 위한 pem키를 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing) 에 업로드해주세요
- [x] pem 키 업로드  

2. 업로드한 pem키는 무엇인가요.
- [KEY-soongjamm.pem](https://drive.google.com/file/d/1vOaTsEJAv2VJh1ex_ticxX7BgsGA0_9C/view?usp=sharing)

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 192.168.5.0/24 

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://soongjamm-infra-web.p-e.kr:8080/ 
- public IP : 3.39.153.56



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://soongjamm-infra-web.p-e.kr/

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

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 배포 열차 출발 칙칙폭폭🚂 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"
function moveToRepository() {
  cd `find ~/* -name ${REPOSITORY_NAME}`

  if [ $? -ne 0 ]; then
        echo -e ${txtred}">> Fail to Move Directory "${txtrst}
        exit
  fi
}

function pull() {
  echo -e ""
  echo -e ">> Pull recent changes 🎣 "
  git pull origin ${BRANCH}
}

function build() {
  echo -e ""
  echo -e ">> Build project 🏗  "
  ./gradlew clean build

  if [ $? -ne 0 ]; then
        echo -e ${txtred}">> Fail to Build "${txtrst}
        exit
  fi
}

function lookupAndKillServerProcess() {
  echo -e ""
  serverPID=`lsof -t -i :${SERVER_PORT}`

  if [ -z "$serverPID" ]
  then
          echo -e ">> There is no server running on port ${SERVER_PORT}."
  else
          echo -e ">> There is a server already running on port ${SERVER_PORT}."
          echo -e ">> The server would be down.."
          kill -2 ${serverPID}
  fi
}

function serverUp() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  서버를 실행합니다. 🥳 ${txtrst}"
  echo -e ""
  echo -e "${txtylw}=======================================${txtrst}"
  jarDir=`find ./* -name *jar`
  nohup java -Dspring.profiles.active=${PROFILE} -Dserver.port=${SERVER_PORT} -jar ${jarDir} 1> ~/logfile 2>&1 &
}

moveToRepository;
pull;
build;
lookupAndKillServerProcess;
serverUp;
                            
```

