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

1. 서버에 접속을 위한 pem키를 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)
   업로드해주세요 - 넹

2. 업로드한 pem키는 무엇인가요.

- bastion 서버 접근용 pem 키 : meeiingjae-keypair.pem
- 내부망 접근용 pem 키 : key-meeingjae.pem

### 1단계 - 망 구성하기

1. 구성한 망의 서브넷 대역을 알려주세요

- 대역 : 192.168.99.0/24
    - public 1 : 192.168.99.0 ~ 192.168.99.63 (/26)
    - public 2 : 192.168.99.64 ~ 192.168.99.127 (/26)
    - private 1 : 192.168.99.128 ~ 192.168.99.160 (/27)
    - bastion 1 : 192.168.99.161 ~ 192.168.99.192 (/27)

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : meeingjae-subway.kro.kr
- IP  : 3.35.131.48:8080

# Subnet

### 192.168.99.0/24

# Key Pair

* key-meeingjae

# EC2

## meeingjae-public-1 (외부망 public 서버)

* instance
    * t3.medium
* subnet
    * 192.168.99.0 ~ 192.168.99.63 (/26)
* public ipv4 address
    * 3.35.131.48
* AZ
    * ap-2a
* Storage
    * 16 GB
* 방화벽(보안 그룹)
    * meeingjae-public-1
        * inound
            * ssh - bastion 서브넷 허용
            * tcp - 8080 포트 허용
            * icmp ipv4 - 모두

## meeingjae-public-2 (외부망 public 서버2)

* instance
    * t3.medium
* subnet
    * 192.168.99.64 ~ 192.168.99.127 (/26)
* public ipv4 address
    * 3.38.207.186
* AZ
    * ap-2b
* Storage
    * 16 GB
* 방화벽(보안 그룹)
    * meeingjae-public-2
        * inound
            * ssh - bastion 서브넷 허용
            * tcp - 8080 포트 허용
            * icmp ipv4 - 모두

## meeingjae-private-1 (내부망 private 서버)

* instance
    * t3.medium
* subnet
    * 192.168.99.128 ~ 192.168.99.160 (/27)
* public ipv4 address
    * 15.164.173.185
* AZ
    * ap-2b
* Storage
    * 8 GB
* 방화벽(보안 그룹)
    * meeingjae-private-1
        * inound
            * ssh - bastion 서브넷 허용
            * tcp - 3306 포트 허용
            * icmp ipv4 - 모두

## meeingjae-bastion-1 (bastion 관리서버)

* instance
    * t3.medium
* subnet
    * 192.168.99.161 ~ 192.168.99.192 (/27)
* public ipv4 address
    * 15.165.59.84
* AZ
    * ap-2b
* Storage
    * 8 GB
* 방화벽(보안 그룹)
    * meeingjae-bastion-1
        * inound
            * ssh - 내 ip
            * icmp ipv4 - 모두

# Internet Gateway

* name
    * meeingjae-internet-gateway

## routing table

* 0.0.0.0 -> meeingjae-internet-gateway

---

### 2단계 - 배포하기

1. TLS가 적용된 URL을 알려주세요

- https://www.meeingjae-subway.kro.kr

### 요구사항 설명

* **운영환경 구성하기**
    * 웹 어플리케이션 앞단에 Reverse Proxy 구성하기
        * 외부망에 Nginx로 Reverse Proxy를 구성
        * Reverse Proxy에 TLS 설정
    * 운영 데이터베이스 구성
* **개발 환경 구성하기**
    * 설정 파일 나누기
        * JUnit : h2
        * Local : docker(mysql)
        * Prod : docker(mysql)

### nginx

- 디렉터리
    - ~/nginx
- 컨테이너
    - name
        - proxy
    - port
        - 80
        - 443
- nginx.conf 경로
    - ~/nginx/nginx.conf

### subway-service

- 디렉터리
    - ~/infra-subway-deploy

- 설정파일 (proerties)
    - application-prod.properties
        - mysql 3306 port
    - application-local.properties
        - mysql 13306 port
    - application-test.properties
        - h2

### subway-db

- Docker Image
    - meeingjae/subway-mysql:0.0.1
- Dockerfile 경로
    - ~/infra-subway-deploy/Dockerfile
- scheam 경로
    - ~/infra-subway-deploy/schema.sql
- 컨테이너 (name)
    - subway-db-prod
        - port : 3306
    - subway-db-local
        - port : 13306

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

* ./deploy.sh ${branch} ${port} ${env}
    * ex) ./deploy.sh meeingjae 8080 prod

```
#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

# 현재 날짜 출력
function printDate() {
  echo -e "스크립트 실행 날짜 : $(date +%Y)년 $(date +%m)월 $(date +%d)일 $(date +%H)시 $(date +%M)분 $(date +%S)초"
}

# Argument 출력
function printArgs() {
  echo -e "${txtgra}"
  echo -e "branch = ${branch}"
  echo -e "port = ${port}"
  echo -e "profile = ${profile} [prod,local,test]"
}

## 저장소 fetch & rebase
function rebase() {
  echo -e "${txtgrn}"
  echo -e ""
  echo -e "fetch branch ${branch}"
  git fetch ${upstream} ${branch}
  echo -e "fetch success"
  echo -e "rebase branch ${branch}"
  git rebase ${upstream}/${branch}
}

## 프로세스 pid 탐색
function findApp() {
  echo -e ${txtylw}
  subwayPid=$(pgrep -f subway.*.jar)
  echo -e "subway application processId = ${subwayPid}"
}

## 프로세스 종료
function killApp() {
  if [[ $subwayPid -gt 0 ]]; then
    echo -e "app pid : ${subwayPid}"
    echo -e ${txtred}
    echo -e "kill ${subwaypid} start"
    kill -15 ${subwayPid}
    sleep 2
    echo -e "subway application stopped"
  fi
}

## 서비스 시작
function startApp() {
  echo -e ${txtylw}
  echo -e "build app"
  ./gradlew clean build
  echo -e "start subway service "
  nohup java -Djava.security.egd=file:/dev/./urandom -Dserver.port=${port} -Duser.language=ko -Duser.country=KO -Dspring.profiles.active=${profile} -jar ./build/libs/subway-0.0.1-SNAPSHOT.jar 1>subwaylog.log 2>&1 &
  echo -e "subway service started"
}

# 브랜치 변경사항 체크 (upstream 브랜치로 대체함)
function checkDiff() {
  echo -e "${txtrst}"
  echo -e "check branch ${branch}"
  currentBranch=$(git rev-parse ${branch})
  echo -e "currentBranch : ${currentBranch}"
  remoteBranch=$(git rev-parse ${origin})
  echo -e "remoteBranch : ${remoteBranch}"

  if [[ "${currentBranch}" == "${remoteBranch}" ]]; then
    echo -e "[$(date)] Nothing to do!!! "
    exit 0
  fi
}

echo -e "---------------- 스크립트 시작 --------------------"
if [ -z "$1"]; then
  profile=prod
else
  profile=$1
fi

branch="step3"
port=8080
upstream="step3"
origin="origin/meeingjae"
cd /home/ubuntu/infra-subway-deploy
# 빌드 실행 날짜 출력
printDate
# 인자 값 출력
printArgs
# 브랜치 변경사항 체크 (빌드 필요 여부 체크)
checkDiff
# 브랜치 변경 사항 pull
rebase
# subway application PID 값 탐색
findApp
# subway application 프로세스 종료
killApp
# subway application 실행
startApp
echo -e "---------------- 스크립트 종료 --------------------"

```

2. crontab 설정
    * `*/5 * * * * ~/infra-subway-deploy/deploy.sh meeingjae 8080 prod >> ~/infra-subway-deploy/deploy_log.log 2>&1`

### 3단계 목표

* public 1 서버에 web(nginx)를 구성한다
* public 2 서버에 was(subway web service)를 구성한다
* 통신의 흐름은 `Internet Gateway` -> `public 1(nginx)` -> `public 2(was)` -> `private 1(mysql)`

### 힌트

* 반복적으로 사용하는 명령어를 script로 작성해보자
* 기능 단위로 함수를 만들어 보자
* 스크립트 실행 시 파라미터를 전달해보자
* 반복적으로 동작하는 스크립트(cron)를 작성해보자


* `crontab`과 `/etc/crontab`의 차이
    * `crontab`은 user별로 cron 설정을 하는 것
        * `crontab`은 각 user별로 cron 작업을 수행하기에 다른 서비스에 영향을 미치지 않고 사용자 별 격리된 cron 작업이 가능하다는 장점이 있지만, 다중 서비스 환경에서 모든 서비스의
          cron 작업을 변경해야하는 경우, 각각의 user에 로그인해서 바꿔줘야하는 불편함이 있다
    * `/etc/crontab` = root(중앙) 에서 cron 설정을 하는 것(user 명시 가능)
        * `/etc/crontab`을 이용하면 다중 서비스 운영 환경일 경우, 중앙에서 모든 서비스의 cron 작업을 컨트롤 가능하다는 장점이 있지만, 모든 권한을 갖고 있는 root가 모든 서비스에
          관여하기 때문에 운영하는 사람의 실수로 서비스 장애가 발생할 수 있다는 단점이 있다

    * 개인적으로 격리된 환경을 좋아하기에 이번 미션에서는 `crontab -e` 기능을 사용하도록 함