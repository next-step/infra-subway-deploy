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
-[X] 업로드 완료
2. 업로드한 pem키는 무엇인가요.
 - [X] gyeom_pem_key.pem
 - [X] gyeom_pem_key2.pem (gyeom-ec2-internal2 용 추가)
### 1단계 - 서비스 구성하기

### 요구사항 체크리스트

#### 망 구성
- [X] VPC 생성
    -[X] CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성
- [X] Subnet 생성
    -[X] 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
    -[X] 내부망으로 사용할 Subnet : 32개씩 1개
    -[X] 관리용으로 사용할 Subnet : 32개씩 1개
- [X] Internet Gateway 연결
- [X] Route Table 생성
- [X] Security Group 설정
    -[X] 외부망
        - 전체 대역 : 8080 포트 오픈
        - 관리망 : 22번 포트 오픈
    -[X] 내부망
        - 외부망 : 3306 포트 오픈
        - 관리망 : 22번 포트 오픈
    -[X] 관리망
        - 자신의 공인 IP : 22번 포트 오픈
-[X] 서버 생성
    - [X] 외부망에 웹 서비스용도의 EC2 생성
        - gyeom-infra-subway-deploy-subnet-public1-ap-northeast-2a
        - gyeom-infra-subway-deploy-subnet-public2-ap-northeast-2b
    - [X] 내부망에 데이터베이스용도의 EC2 생성
        - gyeom-infra-subway-deploy-subnet-private1-ap-northeast-2a
    - [X] 관리망에 베스쳔 서버용도의 EC2 생성
        - gyeom-infra-subway-deploy-subnet-private2-ap-northeast-2b
    - [X] 베스쳔 서버에 Session Timeout 600s 설정
    - [X] 베스쳔 서버에 Command 감사로그 설정

#### 웹 애플리케이션 배포
- [X] 외부망에 웹 애플리케이션을 배포
- [X] DNS 설정


1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 192.168.10.0

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : 3.39.220.195 (http://gyeom-subway-admin.kro.kr:8080)



---

### 2단계 - 배포하기

### 요구사항 체크리스트

#### 운영 환경 구성하기
- [X] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
    -[X] 외부망에 Nginx로 Reverse Proxy를 구성
  -[X] Reverse Proxy에 TLS 설정
- [X] 운영 데이터베이스 구성하기

#### 개발 환경 구성하기
-[X] 설정 파일 나누기
    - JUnit : h2, Local : docker(mysql), Prod : 운영 DB를 사용하도록 설정
    

1. TLS가 적용된 URL을 알려주세요

- URL : https://gyeom-subway-admin.kro.kr/

---

### 3단계 - 배포 스크립트 작성하기
### 요구사항
- [x] 배포 스크립트 작성하기  


1. 작성한 배포 스크립트를 공유해주세요.
- 작업 파일 경로 : /home/ubuntu/nextstep/infra-subway-deploy/deploy.sh
```
#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2
PARAMS_COUNT=$#
APPLICATION_JAR="subway_application.jar"

function vaildate_parameter() {
    if [ $PARAMS_COUNT -ne 2 ] || [ $PROFILE != "prod" ];
    then
        echo -e "${txtylw}=======================================${txtrst}"
        echo -e "${txtgrn}  << validate parameter >> ${txtrst}"
        echo -e ""
        echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod }"
        exit
    fi
}

function pull() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << git checkout $BRANCH >> ${txtrst}"
    git checkout $BRANCH

    echo -e "${txtgrn}  << git pull >> ${txtrst}"
    git pull origin $BRANCH
}

function build() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << gradle build >> ${txtrst}"
    ./gradlew clean build
    mv ./build/libs/*.jar ./build/libs/$APPLICATION_JAR
}


function find_process() {
    echo $(pgrep -f $APPLICATION_JAR)
}


function kill_process() {
    if [ -n "$1" ]
    then
        echo -e "${txtylw}=======================================${txtrst}"
        echo -e "${txtgrn}  << process kill $1 >> ${txtrst}"
        kill -15 $1
    fi
}

function run() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << spring application run >> ${txtrst}"
    nohup java -jar -Dspring.profiles.active=$PROFILE ./build/libs/$APPLICATION_JAR > subway-deploy.log 2>&1 &
}

function deploy() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << deploy 🧐 >>${txtrst}"
    cd $SHELL_SCRIPT_PATH
    vaildate_parameter
    pull
    build
    kill_process $(find_process)
    run
    echo -e "${txtgrn}  << deploy finish >> ${txtrst}"
    echo -e "${txtylw}=======================================${txtrst}"
}

deploy;
```
