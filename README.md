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

2. 업로드한 pem키는 무엇인가요. : `wu22e-key.pem`


### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 외부망(wu22e-public-a) 대역 : 192.168.22.0/26
- 외부망(wu22e-public-c) 대역 : 192.168.22.64/26
- 내부망(wu22e-internal-a) 대역 : 192.168.22.128/27
- 관리망(wu22e-management-c) 대역 : 192.168.22.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://www.wu22e-subway.kro.kr:8080 (13.124.200.219:8080)



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://wu22e-subway.kro.kr

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

```shell
#!/bin/bash

## 변수 설정
REPOSITORY=/home/ubuntu/nextstep/infra-subway-deploy
BUILD_PATH=./build/libs
BRANCH=$1
PROFILE=$2

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << Script 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

function valid_parameter() {
  if [ "$BRANCH" == ""  ]; then
    echo "please write deploy target branch"
    exit 1
  fi
  case "$PROFILE" in
    "prod") ;; "test") ;; "local") ;;
    *) echo "please write deploy target environment"
       exit 1;;
  esac
}

function check_current_branch() {
  echo -e ""
  echo -e ">> Check Current Branch 🏃♂️ "
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  if [ "$current_branch" != "$BRANCH" ]; then # 여기서 비교를 못하는 듯;; (crontab 할 때)
    echo -e "please check current branch and checkout deploy target branch. Current branch -> ${current_branch}"
    exit 1
  fi
  echo -e "current branch -> ${current_branch}"
}

## git branch 변경 사항 체크
function check_branch_df() {
  echo -e ""
  echo -e ">> Check Branch Difference 🏃♂️ "
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 1
  fi
}

## 배포할 브랜치 저장소 pull
function pull_branch() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin deploy
}

## gradle build
function build_application() {
  echo -e ""
  echo -e ">> Gradle build 🏃♂️ "
  ./gradle clean build
}

## 작동중인 어플리케이션 프로세스 pid를 찾는 명령어
function check_exists_process_pid() {
  echo -e ""
  echo -e ">> Check pid and kill pid if exists 🏃♂️ "
  CURRENT_PID=$(pgrep -f java)
  if [ -z "$CURRENT_PID" ]; then
    echo "No exist application."
  else
    echo "Kill exist application"
    kill -9 "$CURRENT_PID"
  fi
}

function run_application() {
  echo -e ""
  echo -e ">> Run application 🏃♂️ "
  JAR_NAME=$(ls ${BUILD_PATH} | grep jar | tail -n 1)
  nohup java -Dspring.profiles.active="${PROFILE}" -Djava.security.egd=file:/dev/./urandom -jar ${BUILD_PATH}/"${JAR_NAME}" 1> application.log 2>&1 &
}

## deploy.sh 파라미터 유효성 검증
valid_parameter;

## 현재 branch 확인
check_current_branch

## branch 변경 유무 확인
check_branch_df;

## remote branch 로컬 반영
pull_branch;

## 어플리케이션 빌드
build_application;

## 실행 중인 어플리케이션 프로세스 종료
check_exists_process_pid;

## 어플리케이션 실행
run_application;
```


