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
* hae-gun-key.pem


### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 
  - public-a: 192.168.10.0/26
  - public-c: 192.168.10.64/26
  - internal-a: 192.168.10.128/27
  - admin-a: 192.168.10.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요
- URL : http://infra-haegun.kro.kr/

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://inrfa-haegun.r-e.kr/

<b>docker 설치후 sudo 권한없이 실행설정</b>
```shell
$ sudo groupadd docker # 그룹 설정 안했을 시
$ sudo usermod -aG docker $USER
$ newgrp docker
```
---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요. 

* deploy_server.sh
```shell
  
#!/bin/bash
## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray
REPOSITORY=~/nextstep/infra-subway-deploy
LOG_PATH=../log/subway-deplog.log
APP_NAME=infra-subway-deploy
BRANCH=$1
PROFILE=$2
if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << IS NOT AVAILABLE INPUT 👎 >>${txtrst}"
    echo -e "${txtgrn}  << 스크립트 😹 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ test | local | prod }"
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 로컬브렌치 리스트  >>${txtrst}"
    echo -e "${txtylw}====👇👇👇👇===========================${txtrst}"
    cd ${REPOSITORY}
    git branch -a | grep -v remotes/
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi 
function move() {
        cd ${REPOSITORY}
}
function check_df() {
        git fetch
        master=$(git rev-parse $BRANCH)
        remote=$(git rev-parse origin/$BRANCH)
        if [[ $master == $remote ]]; then
                echo -e "[$(date)] Nothing to do!!! 😫"
                exit 1
        fi
}
function pull() {
        echo -e ""
        echo -e ">> 🚀  Pull Request  🚀"
        git pull
}
function build() {
        echo -e ""
        echo -e ">> 🏗️  Build 🏗️"
        ./gradlew clean build
        echo -e ">> 😎 Build is Success 😎"
}
function stop() {
        echo -e ""
        echo -e ">> 🔴 Stop Exist Application 🔴"
        pkill -f ${APP_NAME}
        while pgrep -f ${APP_NAME} >/dev/null; do sleep 1; done
}
function start() {
        echo -e ""
        echo -e ">> 🏃🏻 Start New Application 🏃🏻"
        nohup java -DAPP_NAME=${APP_NAME} -Dspring.profiles.active=${PROFILE} -jar ./build/libs/subway-0.0.1-SNAPSHOT.jar 1> ${LOG_PATH} 2>&1 &
}
move;
check_df;
pull;
build;
stop;
start;
```


