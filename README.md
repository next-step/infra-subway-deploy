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
    * KEY-limhangyeol.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 :
   - limhangyeol-public-a: 192.168.2.0/26
   - limhangyeol-public-c: 192.168.2.64/26
   - limhangyeol-internal-a: 192.168.2.128/27
   - limhangyeol-admin-c: 192.168.2.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL :
   - http://limhangyeol.kro.kr:8080/
   - http://3.37.3.109:8080/



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://limhangyeol.kro.kr

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
- deploy.sh

```shell
#!/bin/bash

## 자주 사용하는 값 변수에 저장
repository=/home/ubuntu/nextstep
project=infra-subway-deploy
current_path=$(pwd)
branch=$1
profile=$2

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

function start() {
    ## 조건 설정
    if [[ $# -ne 3 ]]
    then
        echo -e "${txtylw}=======================================${txtrst}"
        echo -e "${txtgrn}  << 배포 스크립트 실행 ${0} >>${txtrst}"
        echo -e ""
        echo -e "${txtgrn}  << Branch: ${branch}, Profile: ${profile} >> ${txtrst}"
        echo -e "${txtylw}=======================================${txtrst}"
    fi
}

function pull() {
    # cd project path
    cd $repository/$project/

    # git branch pull
    echo -e "${txtgrn} << 현재 위치 ${current_path} >> ${txtrst}"
    echo -e "${txtgrn} << Git Branch Pull >> ${txtrst}"
    git pull
}

function build() {
    # gradle clean build
    echo -e "${txtgrn} << Project Clean Build >> ${txtrst}"
    ./gradlew clean build
}

function validate() {
    ## 프로세스 pid 탐색
    echo -e "${txtgrn} << 현재 동작중인 프로세스 PID 탐색 >> ${txtrst}"
    current_pid=$(pgrep -f ${project}.*.jar)

    ## 프로세스 pid 종료
    if [ -z "$current_pid" ]; then
        echo -e "${txtgrn} << 현재 동작중인 애플리케이션이 없음 >> ${txtrst}"
    else
        echo -e "${txtgrn} << 현재 동작중인 프로세스 PID: $current_pid >> ${txtrst}"
        echo -e "${txtred} << kill -15 $current_pid >> ${txtrst}"
        kill -15 $current_pid
        sleep 5
    fi
}

function deployment() {
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 프로젝트 배포 >>${txtrst}"
    echo -e "${txtylw}=======================================${txtrst}"
    
    jar_path=./build/libs
    java -jar -Dspring.profiles.active=prod $jar_path/subway-0.0.1-SNAPSHOT.jar
}

function run() {
    # cd project path
    cd $repository/$project/

    # git branch validation
    git fetch
    master=$(git rev-parse $branch)
    remote=$(git rev-parse origin/$branch)

    echo -e "${txtgrn} << Git Diff Check >> ${txtrst}"
    echo -e "${txtgrn} << master revision: ${master} >> ${txtrst}"
    echo -e "${txtgrn} << remote revision: ${remote} >> ${txtrst}"
    if [[ $master == $remote ]]; then
        echo -e "[$(date +"%Y-%m-%d %T")] Nothingg to do!!!"
        exit 0
    else
        start;
        pull;
        build;
        validate;
        deployment;
    fi
}

run;

```

2. crontab
```shell
# infra-subway-deploy project cron deployment
* * * * * ubuntu /home/ubuntu/nextstep/infra-subway-deploy/./deploy.sh step4 prod >> /home/ubuntu/nextstep/infra-subway-deploy/log/deploy.sh.log 2>&1
```
