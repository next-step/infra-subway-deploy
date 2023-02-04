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

- 미션 진행 후에 아래 질문의 답을 README.md 파일에 작성하여 PR을 보내주세요.

### 0단계 - pem 키 생성하기

1. 서버에 접속을 위한 pem키를 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요

2. 업로드한 pem키는 무엇인가요.

- Seung-wan-key.pem

- pem키는 EC2 인스턴스에 ssh 접속을 하기 위해 사용됩니다. EC2에 접속하기 위해서 공개키 형식을 사용하고 있는데 pem키를 생성하면 비밀키를 다운로드받게 됩니다. pem키를 이용하여 인스턴스를 생성하면 인스턴스의 ~/.ssh/authorized_keys 파일에 생성한 pem키에 맞는 공개키가 생성됩니다.
  pem키를 이용하여 인스턴스에 접근하려고 하면 인스턴스는 pem키로 암호화된 정보를 authorized_keys 파일에 존재하는 공개키로 복호화를 시도하고, 성공했다면 인스턴스에 접속할 수 있게 됩니다.

### 1단계 - 망 구성하기

1. 구성한 망의 서브넷 대역을 알려주세요

- 대역 :
  - Seung-wan-public-a: 192.168.3.0/26
  - Seung-wan-public-c: 192.168.3.64/26
  - Seung-wan-internal-a: 192.168.3.128/27
  - Seung-wan-bastion-a: 192.168.3.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://infra-seungwan.kro.kr/

---

### 2단계 - 배포하기

1. TLS가 적용된 URL을 알려주세요

- URL : https://seungwan.p-e.kr/

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

```bash
#!/bin/bash

txtrst='\033[1;37m'
txtred='\033[1;31m'
txtylw='\033[1;33m'
txtpur='\033[1;35m'
txtgrn='\033[1;32m'
txtgra='\033[1;30m'


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)


echo -e "Enter branch name"
read BRANCH

echo -e "Enter ENV name"
read ENV

echo -e "Enter .jar directory for running server"
read JAR


check_df() {
  git fetch
  local master=$(git rev-parse $BRANCH)
  local remote=$(git rev-parse origin/$BRANCH)

  echo $master
  echo $remote

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 1
  fi
}

pull() {
  echo -e ""
  echo -e "Github Pull Request..."
  git pull origin ${BRANCH}
}

build_gradle() {
  echo -e ""
  echo -e "Build With Gradle..."
  ./gradlew clean build
}

kill_process() {
 echo -e ""
 echo -e "Find Pid..."

 local java_pid=$(pgrep -f java)
 kill -2 $java_pid

 sleep 3
}

run(){
 nohup java -jar -Dspring.profiles.active=${ENV} ${JAR} &
}

check_df
pull
build_gradle
kill_process
run
```
