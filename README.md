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

### 1단계 - 망 구성하기

![image](https://user-images.githubusercontent.com/10750614/158056234-01af01ab-6fb8-4010-ae47-715da39ddd3c.png)

1. 구성한 망의 서브넷 대역을 알려주세요
- vpc : 192.168.55.0/24 
- public subnet1 : 192.168.55.0/26
- public subnet2 : 192.168.55.64/26
- internal subnet : 192.168.55.128/27
- bastion subnet : 192.168.55.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://infra.jdragon.r-e.kr:8080/

3. 베스천 서버에 접속을 위한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요
- 
- koola97620-infra-key.pem
- koola97620-infra-ssh-key.ppk
---

### 2단계 - 배포하기

Nginx 구성 입니다.
![image](https://user-images.githubusercontent.com/10750614/158430759-faffa6d5-b77d-4dac-94e2-7b2c185327e8.png)

1. TLS가 적용된 URL을 알려주세요

- URL : https://jdragon.r-e.kr/

---


### [추가] 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.  

```shell

#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

BRANCH=$1
PROFILE=$2

if [[ $# -ne 1 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >> $0      ${txtrst}"
    echo -e ""
    echo -e "${txtgrn} BRANCH:${BRANCH} PROFILE:${PROFILE}   "
    echo -e "${txtylw}=======================================${txtrst}"

fi

function check_df() {
        echo -e "[$(date)] Start Check Diff Git Changes!!!"

        cd /home/ubuntu/infra-subway-deploy
        git fetch
        master=$(git rev-parse ${BRANCH})
        remote=$(git rev-parse origin/${BRANCH})

        echo "master:${master}"
        echo "remote:${remote}"

        if [[ $master == $remote ]]; then
                echo -e "[$(date)] Nothing to do!!! 😫"
                exit
        fi
}

function search_pid() {
        echo `jps | grep subway | awk '{print $1}'`
}

function stop_app() {
        echo -e "[$(date)] Stop Application..."
        PID=$(search_pid)
        if [ -n "${PID}" ]
        then
                echo "kill app - pid:${PID}"
                kill -9 ${PID}
        else
                echo "APPLICATION IS NOT START"
        fi
}

function pull() {
        echo -e "[$(date)] Pull!!! 😫"
        cd /home/ubuntu/infra-subway-deploy
        git pull origin ${BRANCH}
}

function start_app() {
        echo -e "[$(date)] Start Application!!! 😫"
        nohup java -jar -Dspring.profiles.active=${PROFILE} /home/ubuntu/infra-subway-deploy/build/libs/subway-0.0.1-SNAPSHOT.jar > /home/ubuntu/logs/infra_deploy.log 2>&1 &
}

check_df
pull
stop_app
start_app

```


2. cronjob 설정을 공유해주세요.
- */30 * * * * /home/ubuntu/infra-subway-deploy/deploy.sh step2 prod >> /home/ubuntu/cronlogs/infra_deploy_cron.log 2>&1 &
