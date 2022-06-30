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
- 업로드한 pem키: KEY-jeongjaeeom

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 192.168.100.0/24

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://www.devdog.p-e.kr



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://www.devdog.p-e.kr

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
#### 배포스크립트
```shell
#!/bin/bash
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

function check_df() {
  git fetch origin $BRANCH
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi
}

function pull() {
  git rebase origin/$BRANCH
}

function build() {
  ./gradlew clean build
  JAR_NAME=$(ls ./build/libs/*.jar | grep subway)
  echo "jar: ${JAR_NAME}"
}

function check_pid() {
  PID=$(pgrep -f ${JAR_NAME})
  echo "PID: ${PID}"
}

function kill_process() {
  if [ -z ${PID} ]
  then
    echo "The process is not running."
  else
    kill -15 ${PID}
    echo "Kill process: ${PID}"
    sleep 5
  fi
}

function run() {
  echo "Run Application"
  nohup java -jar -Dspring.profiles.active=${PROFILE} ./build/libs/*.jar 1> ../infra-subway-logs/subway.log 2>&1 &
}

if [[ $# -ne 2 ]]
then
  echo -e "${txtred}Please check the branch and profile."
  exit
fi

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e ""
echo -e "${txtgrn} Script:${txtylw} $0"
echo -e "${txtgrn} Branch:${txtred} ${BRANCH}"
echo -e "${txtgrn} Profile:${txtred} ${PROFILE}"
echo -e "${txtylw}=======================================${txtrst}"

# Move target directory
cd $SHELL_SCRIPT_PATH/infra-subway-deploy

# Check revision
check_df;

# Git Pull
pull;

# Gradle build
build;

# Check PID
check_pid;

# Kill process
kill_process;

# Run application
run;

exit
```

#### 크론탭
```shell
* * * * * /home/ubuntu/nextstep/deploy.sh main prod >> /home/ubuntu/nextstep/deploy.log
```