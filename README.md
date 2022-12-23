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
    - key-deokmoon.pem
### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 192.168.47.0/24

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : 3.38.166.210
- https://www.aws-nextstep-deokmoo.kro.kr/


이외 미션 수행 정보
   - 인스턴스
      - deokmoon-t3-DB-EC2
      - deokmoon-t3-public-EC2
      - deokmoon-bastion-EC2
   - 보안그룹
      - SG-deokmoon-bastion
      - SG-deokmoon-private
      - SG-deokmoon-public
   - vpc
      - deokmoon-vpc
   - 라우팅 테이블
      - deokmoon-private-rt
      - deokmoon-public-rt
   - nat
      - deokmoon-nat
   - igw
      - deokmoon-igw
   - 서브넷 정보
      - public-1: 192.168.47.0/26
      - public-2: 192.168.47.64/26
      - private: 192.168.47.128/27
      - admin(bastion): 192.168.47.160/27
   
---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : 
   - https://www.aws-nextstep-deokmoo.kro.kr/
   - https://3.38.166.210/
2. 이외 내용
   - project 폴더 경로
      - ~/nextstep
   - Dockerfile 경로
      - ~/nextstep/infra-subway-deploy
---
### Step1, Step2 회고
* Step1을 구성하면서 그 동안 프로그램을 구현했던 기반 서비스의 아키텍처를 알게되는 계기가 됨
* infra 미션이라 각 용어가 생소하여 찾아가며 바로 적용하느라 readme에 요구사항을 정리하지 않고 진행하다보니 실수 발생
    * nohup 이슈
    * 요구사항 누락(properties 구성)

---
### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

~~~shell
#!/bin/bash

## 변수 설정
PROJECT_PATH=/home/ubuntu/nextstep/infra-subway-deploy
LIBRAY_PATH=/home/ubuntu/nextstep/infra-subway-deploy/build/libs
APP_NAME=subway-0.0.1-SNAPSHOT.jar
BRANCH_NAME=deokmoon


txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 START 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

## 저장소로 이동
function movePath() {
 cd $PROJECT_PATH
 echo -e "MOVE PATH[$PROJECT_PATH]"
}

## 저장소 중복 체크
function check_git_diff() {
git fetch origin

echo  -e "git rev-parse $BRANCH_NAME"
echo  -e "git rev-parse origin/$BRANCH_NAME"

MASTER=$(git rev-parse $BRANCH_NAME)
REMOTE=$(git rev-parse origin/$BRANCH_NAME)

echo -e ""
echo -e ">> Git Diff Check"
echo -e "MASTER[$MASTER]"
echo -e "REMOTE[$REMOTE]"

if [[ $MASTER == $REMOTE ]]; then
  echo -e "[$(date)] Nothing git diff!!! 😫"
  exit 0
fi

echo -e "<< Git Diff Sucess"
}
## 저장소 pull
function pull() {
 echo -e ""
 echo -e ">> GIT Pull Request 🏃♂️ "
   git pull
 echo -e "<< Git Pull Sucess"
}
## 빌드
function build() {
 echo -e ""
 echo -e ">> Build Start 🏃♂️"
  $PROJECT_PATH/gradlew clean build
 echo -e ">> Build Sucess"
}
## 프로세스 종료
function stop() {
 echo -e ""
 echo -e ">> Process Stop 🏃♂️"

 PID=$(pgrep -f $APP_NAME)

 if [ -z $PID ]; then
         echo -e ">> Process Not Exists"
 else
       echo -e  ">> Kill -15 $PID"
        kill -15 $PID
        sleep 6
 fi

 echo -e "<< Process Stop Sucess"
}

## 프로세스 실행
function start() {
 echo -e ""
 echo -e ">> Process ReStart 🏃♂️"
   echo -e "nohup java -jar -Dspring.profiles.active=prod  $LIBRAY_PATH/$APP_NAME 1> $PROJECT_PATH/service.log 2>&1  &"
   nohup java -jar -Dspring.profiles.active=prod $LIBRAY_PATH/$APP_NAME 1> $PROJECT_PATH/service.log 2>&1  &
 echo -e "<< Process ReStart Sucess"
}

## 스크립트 스타트 ###

# 저장소로 이동
movePath

# git diff check
check_git_diff

# git pull
pull

# project build
build

# process kill
stop

# process restart
start

### 스크립트 종료 ###

~~~
