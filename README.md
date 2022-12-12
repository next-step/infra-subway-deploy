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
- 올렸습니다

2. 업로드한 pem키는 무엇인가요. 
- KEY-happy-dev-travel.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 
- happy-dev-travel-admin / 192.168.77.160/27
- happy-dev-travel-public-c / 192.168.77.64/26
- happy-dev-travel-public-a / 192.168.77.0/26
- happy-dev-travel-internal-a / 192.168.77.128/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : https://happy-subway.kro.kr



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://happy-subway.kro.kr

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
````bash
#!/bin/bash
## 색상 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray
echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"
## 변수 설정
PROJECT_PATH=/home/ubuntu/nextstep/infra-subway-deploy
## 프로젝트 경로로 이동
function changeDirectoryToProject() {
echo -e "${txtgrn}>> Move to Project Directory${txtrst}"
cd $PROJECT_PATH
}
## 저장소 pull
function pull() {
echo -e ""
echo -e "${txtgrn}>> PULL main BRANCH ${txtrst}"
git pull origin main
}
## gradle build
function build() {
echo -e ""
echo -e "${txtgrn}>> BUILD${txtrst}"
./gradlew clean build
}
## 프로세를 KILL 하는 명령어
function killProcess() {
echo -e ""
echo -e "${txtgrn}>> KILL PROCESS${txtrst}"
PID=$(lsof -ti tcp:8080)
if [ -z "${PID}" ]
then
echo "> NO RUNNING PROCESS IN PORT 8080"  
else
echo -e "KILL ${PID}"
kill -9 "${PID}"
fi
}
## 애플리케이션을 실행
function run() {
echo -e ""
echo -e "${txtgrn}>> RUN APPLICATION ${txtrst}"
JAR_PATH=$(find $PROJECT_PATH/build/libs/*jar)
JAR_NAME=$(basename "$JAR_PATH")
echo -e "Jar name is ${JAR_NAME}"
nohup java -jar -Dspring.profiles.active=prod ./${JAR_NAME} 1> ./subway.log 2>&1  &
}
changeDirectoryToProject;
pull;
build;
killProcess;
run;
````
