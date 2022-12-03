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
 - 업로드 하였습니다.
2. 업로드한 pem키는 무엇인가요.
 - aksgudwns-key.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 192.168.31.0/26(public-1), 192.168.31.64/26(public-2), 192.168.31.128/27(internal), 192.168.31.160/27(admin)

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요
- URL : http://nextstep-aksgudwns.p-e.kr:8080/



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://nextstep-aksgudwns.p-e.kr/

#### 요구사항
* 운영 환경 구성
- [x] 웹 애플리케이션 앞단에 Reverse Proxy 구성
- [x] Reverse Proxy에 TLS 설정
- [x] 컨테이너로 운영 DB 사용하기
- [x] 설정파일 분리
- [x] git submodule을 통한 설정 별도로 관리하기

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
아래 공유해드립니다. 위치는 /nextstep/deploy.sh 입니다.

deploy.sh
---------------------------------------------------------------
#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

REPOSITORY=~/nextstep
PROJECT_NAME=infra-subway-deploy
FIND_JAR_NAME=subway

LOGPATH=~/nextstep/log
LOGFILENAME=log_$(date '+%Y-%m-%d_%H:%M:%S').out

EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

## 함수작성

## 저장소 pull
function pull() {
cd $REPOSITORY/$PROJECT_NAME/
echo -e ""
echo -e ">> Pull Request 🏃♂️ "
git pull origin $BRANCH
}

## github branch 변경사항이 있는 경우에만 동작
function check_df() {
cd $REPOSITORY/$PROJECT_NAME/
git fetch
master=$(git rev-parse $BRANCH)
remote=$(git rev-parse origin/$BRANCH)

if [[ $master == $remote ]]; then
echo -e "[$(date)] Nothing to do!!! 😫"
exit 0
fi
}

## gradle build
function build() {
cd $REPOSITORY/$PROJECT_NAME/
echo -e ""
echo -e ">> Gradle build 🏃♂️ "
SPRING_PROFILES_ACTIVE=$PROFILE ./gradlew clean build
}

## 프로세스 pid를 찾아서 있는 경우 종료
function processFindAndKill() {
echo -e ""
echo -e ">> 현재 구동중인 프로세스 확인 🏃♂️ "

CURRENT_PID=$(pgrep -f $FIND_JAR_NAME)

if [ -z $CURRENT_PID ]; then
echo "> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."

else
echo "> kill -2 $CURRENT_PID"
kill -2 $CURRENT_PID
sleep 5
CURRENT_PID2=$(pgrep -f $FIND_JAR_NAME)
if [ -z $CURRENT_PID2 ]; then
echo ">정상종료되었습니다."
else
echo ">강제 종료합니다."
kill -9 $CURRENT_PID2
sleep 5
fi
fi
}

##애플리케이션 구동
function run() {
echo -e ""
echo -e ">> 새 애플리케이션 배포 🏃♂️ "
cp $REPOSITORY/$PROJECT_NAME/build/libs/*.jar $REPOSITORY/
cd $REPOSITORY
JAR_NAME=$(ls -tr $REPOSITORY/ | grep $FIND_JAR_NAME | tail -n 1)
echo "> JAR Name : $JAR_NAME"
nohup java -jar -Dspring.profiles.active=$PROFILE $JAR_NAME  1> $LOGPATH/$LOGFILENAME 2>&1  &

}





##여기부터 시작

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

pull;
check_df;
build;
processFindAndKill;
run;


테스트
