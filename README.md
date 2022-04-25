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
- `KEY-NEXTSTEP-tmdgusya.pem` 입니다.

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 
  - 외부망 
    - 1 : tmdgusya-external (192.168.1.0/26):ap-northeast-2a
    - 2 : tmdgusya-external-2 (192.168.1.128/26):ap-northeast-2b
  - 내부망 : tmdgusya-internal (192.168.1.64/27):ap-northeast-2a
  - 어드민 : tmdgusya-admin (192.168.1.96/27):ap-northeast-2a

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://www.roach.p-e.kr:8080/



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://www.roach.p-e.kr/

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

### start.sh

```shell
sudo bash ./start.sh tmdgusya prod /home/ubuntu/nextstep/infra-subway-deploy
```

### server.sh

```shell
#!/bin/bash

## env
BRANCH=$1
PROFILE=$2
PROJECT_FOLDER=$3

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

## setup
git config --global --add safe.directory $PROJECT_FOLDER

function check_df() {
  cd $PROJECT_FOLDER
  git fetch
  master=$(git rev-parse $BRANCH > /dev/null 2>&1)
  remote=$(git rev-parse origin $BRANCH > /dev/null 2>&1)

  if [[ $master == $remote ]]; then
    cd ..
    isNeedUpdateBranch=1
  else
    cd ..
    isNeedUpdateBranch=0
  fi
  echo "$isNeedUpdateBranch"
}

function printMessage() {
  local message=$1
  echo -e "${txtpur}=======================================${txtrst}"
  echo -e "${txtgrn}  <<${message}>>${txtrst}"
  echo -e "${txtpur}=======================================${txtrst}"
}

function printErrorMessage() {
  local message=$1
  echo -e "${txtred}=======================================${txtrst}"
  echo -e "${txtred}  <<${message}>>${txtrst}"
  echo -e "${txtred}=======================================${txtrst}"
}

function githubClone() {
  printMessage "Check Branch Need Update...."

  result=$(check_df)

  if [ "$result" == 0 ]
  then
    printMesage "Branch Update..."
    cd $PROJECT_FOLDER && git pull origin tmdgusya
    cd ..
  else
    printMessage "Current Branch is already updated"
  fi

}

function projectBuild() {
  printMessage "Project Build...."
  cd $PROJECT_FOLDER && ./gradlew clean build && cd ..
}

function startServer() {
  printMessage "Server Start.... CURRENT PROFLE = $PROFILE"
  nohup java -jar -Dspring.profiles.active=$PROFILE $PROJECT_FOLDER/build/libs/subway-0.0.1-SNAPSHOT.jar 1> ./log/spring.log 2>&1  &
}

function healthCheck() {
  curl localhost:8080
}

function healthWithMessage() {
  printMesage "Health Check..."
  if [ -z "$(healthCheck)" ]
  then 
    printErrorMessage "Server Not Healthy"
  else 
    printMessage "Server is Healthy"
  fi
}

## function
printMessage "서버구동 스크립트 시작!"

## function
githubClone

## function
projectBuild

## function
startServer

## function
healthWithMessage
```

