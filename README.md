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
> 업로드 했습니다!

2. 업로드한 pem키는 무엇인가요.
>choizz-key
### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 :
vpc : 192.168.15.0/24
외부망1: 192.168.15.0/26
외부망2: 192.168.15.64/26
내부망: 192.168.15.128/27
관리망: 192.168.15.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : 3.39.228.104 , choizz.o-r.kr //도메인 교체

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://choizz.o-r.kr/ 
---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
```shell
#!/bin/bash

txtwhite='\033[1;37m'
txtred='\033[1;31m'
txtlw='\033[1;33m'
txtpur='\033[1;35m'
txtgrn='\033[1;32m'
txtgrey='\033[1;30m'

echo -e "${txtpur} =================================="
echo -e "${txtpur} <<<<<<스크립트>>>>>>"
echo -e "${txtpur}==================================${txtgrn}"

EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2
JAR=$3

echo ""
echo "${txtred} >> Pull Request 🚀"

echo ""
echo -e "${txtgrey}실행 경로 : ${EXECUTION_PATH}"
echo -e "${txtpur} 쉘 이름:$0 브랜치 이름 :  $BRANCH ${txtred} 적용 프로파일 : $PROFILE"
echo "$JAR"
echo -e "${txtpur}==============================${txtgrn}"
git pull origin ${BRANCH}

function check_deploy() {

  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  echo $master
  echo $remote

  if [[ $master == $remote ]]; then

    echo "[$(date)] 할게 없음 ㅜㅜ"
    exit 1

  else

    local JAVA_PID=$(pgrep -f java)
    echo -e "${txtpur}============================ ${JAVA_PID} ${txtlw}"
    kill -9 $JAVA_PID

    nohup java -jar -Dspring.profiles.active=${PROFILE} ${JAR} &
    tail -f nohup.out
  fi
}

check_deploy
```

