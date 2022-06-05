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
   - [mond-page-keypair.pem](https://drive.google.com/file/d/1R5r7Sxn7r4uhnb8mnoOt4R7rV4vKQy5R/view?usp=sharing)

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
   - 외부망으로 사용할 Subnet
     - **mond-page-public-subnet-01(192.168.255.192/26), mond-page-public-subnet-02(192.168.255.128/26)**
   - 내부망으로 사용할 Subnet
     - **mond-page-private-subnet-01(192.168.255.96/27)**
   - 관리용으로 사용할 Subnet
     - **mond-page-manage-subnet-01(192.168.255.5/27)**

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요
- IP : 3.35.132.101:8080
- URL : http://subway.mond.page:8080/



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://subway.mond.page

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
```shell
#!/bin/bash

## 컬러
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

## 변수
EXECUTION_PATH="$(pwd)/infra-subway-deploy"
EXECUTION_PORT="8080"
JAR_FILE_NAME="subway-0.0.1-SNAPSHOT.jar"

## 입력 파라미터 함수
function inputUserParams() {
        echo "Phase를 선택해주세요 [local/prod]"
        read phase
        if [[ ${phase} != "prod" ]] && [[ ${phase} != "local" ]]; then
                echo -e "선택하신 ${txtred}${phase}${txtrst}는 없는 Phase입니다."
                exit 0
        fi
}

## Git Pulling 함수
function pullingGit() {
        echo -e "${txtylw}==========  Git Pull 시작 ==========${txtrst}"
        cd ${EXECUTION_PATH}
        git pull origin mond-page
        echo -e "${txtylw}==========  Git Pull 종료 ==========${txtrst}"
}

## Gralde Clean 후 Build 함수
function buildGradle() {
        echo -e "${txtgra}========== Gradle Build 시작 ==========${txtrst}"
        sudo ./gradlew clean build
        echo -e "${txtgra}========== Gradle Build 종료 ==========${txtrst}"
}

## 해당 포트 KILL 함수
function pidKill() {
        echo -e "${txtpur}========== PID KILL 시작 ==========${txtrst}"
        local pid=`sudo lsof -i:${EXECUTION_PORT}`
        if [[ -n ${pid} ]]; then
                sudo kill $(sudo lsof -ti:${EXECUTION_PORT})
        fi
        echo -e "${txtpur}========== PID KILL 종료 ==========${txtrst}"
}

## 서버 시작 함수
function startServer() {
        echo -e "${txtgrn}========== Subway 서버 시작 ==========${txtrst}"
        local JAR_EXE="java -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=${phase} -jar ${EXECUTION_PATH}/build/libs/${JAR_FILE_NAME}"
        nohup ${JAR_EXE} 1> sudo ${EXECUTION_PATH}/application.log 2>&1
}


inputUserParams;
pullingGit;
buildGradle;
pidKill;
startServer;
```

