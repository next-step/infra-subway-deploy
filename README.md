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
   sueh237-KEY.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 
  - sueh237-vpc : 192.168.72.0/24
  - sueh237-public-a : 192.168.72.0/26
  - sueh237-public-c : 192.168.72.64/26
  - sueh237-internal-a : 192.168.72.128/27
  - sueh237-admin-a : 192.168.72.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://sueh237.kro.kr(http://3.36.120.59:8080/)



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://sueh237.kro.kr/

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

- /home/ubuntu/nextstep/deploy.sh
```shell
#! /bin/bash 
## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray
RET_TRUE=1
RET_FALSE=0
EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2
REPOSITORY="/home/ubuntu/nextstep/infra-subway-deploy"
BUILD_PATH="${REPOSITORY}/build/libs"
function usage() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}<< 스크립트 🧐 >>${txtrst}"
  echo -e ""
  echo -e "${txtgrn}$0 branch${txtred}{ main | sueh237 | step3 } ${txtgrn}profile${txtred}{ prod | test | local }"
  echo -e "${txtylw}=======================================${txtrst}"
}
function build() {
  cd ${REPOSITORY}
  check_df;
  pull;
  makeJar;
  shutdownApplication;
  releaseApplication;
}
function check_df() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}<< 저장소 업데이트 🧐 >>${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtylw} >> 브랜치 비교 대상 : ${txtred}$BRANCH${txtrst}"
  git fetch
  
  master_branch=$(git rev-parse $BRANCH)
  remote_branch=$(git rev-parse origin/$BRANCH)
  if [[ $master_branch == $remote_branch ]]; then
    echo -e "${txtylw} >> [$(date)] 변경 된 내용이 없습니다 😫${txtrst}"
    exit 0
  fi
}
function pull() {
  echo -e ""
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}<< Pull Request 🏃♂ >>${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
  git pull origin $BRANCH
}
function makeJar() {
  echo -e ""
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}<< Application 빌드 🧐 >>${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
  ./gradlew clean build
}
function shutdownApplication() {
  echo -e ""
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}<< Application 종료 >>${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
  local appPid=$(pgrep -f subway)
  if [[ -n "$appPid" ]]
  then
    kill -TERM $appPid
    echo -e "${txtylw} >> 종료 완료${txtrst}"
  else
    echo -e "${txtylw} >> 구동중인 Application이 없으므로 종료하지 않습니다.${txtrst}"
  fi
}
function releaseApplication() {
  echo -e ""
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}<< Application 시작 🧐 >>${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
    # tail -n으로 최신 jar 파일 변수에 저장
  local jarName=$(ls $BUILD_PATH | grep 'subway' | tail -n 1)
  echo -e "${txtylw} >> Profile : $PROFILE${txtrst}"
  echo -e "${txtylw} >> JAR : $jarName${txtrst}"
    
  nohup java -jar \
    -Dspring.profiles.active=$PROFILE \
    $BUILD_PATH/$jarName 1> app.log 2>&1  &
  echo -e "${txtylw} >> [$(date)] Application 시작 완료${txtrst}"
}
if [[ $# -ne 2 ]]
then
  usage;
else
  build;
fi
exit;
...