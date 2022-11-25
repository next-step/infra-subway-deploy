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

---
## 미션
* 미션 진행 후에 아래 질문의 답을 README.md 파일에 작성하여 PR을 보내주세요.
---
### 0단계 - pem 키 생성하기
1. 서버에 접속을 위한 pem키를 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요
2. 업로드한 pem키는 무엇인가요.
   - key-sixthou.pem
---
### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 192.168.66.0/24
2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요
- IP : http://3.34.114.64:8080/
- URL : http://subway.sixthou.kro.kr:8080/
---
### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요
- URL : https://subway.sixthou.kro.kr
---
### 3단계 - 배포 스크립트 작성하기
1. 작성한 배포 스크립트를 공유해주세요.

---
## 🚀 1단계 - 서비스 구성하기
### 요구사항
- **웹 서비스를 운영할 네트워크 망 구성하기**
  -[x] VPC 생성
    -[x] CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성
    - sixthou-vpc | 192.168.66.0/24
  -[x] Subnet 생성
    -[x] 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
      - sixthou-public-a | 192.168.66.0/26
      - sixthou-public-b | 192.168.66.64/26
    -[x] 내부망으로 사용할 Subnet : 32개씩 1개
      - sixthou-private-a | 192.168.66.128/27
    -[x] 관리용으로 사용할 Subnet : 32개씩 1개
      - sixthou-admin-a | 192.168.66.160/27
  -[x] Internet Gateway 연결
    - sixthou-internet-gateway
  -[x] Route Table 생성
    - sixthou-route-table-public
      -  0.0.0.0/0 - sixthou-internet-gateway 매핑
    - sixthou-route-table-private
  -[x] Security Group 설정
    -[x] 외부망 - sixthou-security-group-public
      -[x] 전체 대역 : 8080 포트 오픈
      -[x] 관리망 : 22번 포트 오픈
    -[x] 내부망 - sixthou-security-group-private
      -[x] 외부망 : 3306 포트 오픈
      -[x] 관리망 : 22번 포트 오픈
    -[x] 관리망 - sixthou-security-group-admin
      -[x] 자신의 공인 IP : 22번 포트 오픈
  -[x] 서버 생성
    -[x] 외부망에 웹 서비스용도의 EC2 생성
      - ec2-sixthou-public-web(sixthou-public-a)
      - 192.168.66.48
    -[x] 내부망에 데이터베이스용도의 EC2 생성
      - ec2-sixthou-private-db(sixthou-private-a)
      - 192.168.66.154
    -[x] 관리망에 베스쳔 서버용도의 EC2 생성
      - ec2-sixthou-admin-bastion
      - 192.168.66.183
      - 공개키 생성 및 서비스, db서버 등록
      - hosts 등록
    -[x] 베스쳔 서버에 Session Timeout 600s 설정
    -[x] 베스쳔 서버에 Command 감사로그 설정

- **웹 애플리케이션 배포하기**
  -[x] 외부망에 웹 애플리케이션을 배포
    - ~/app/infra-subway-deploy/
    - ~/data/log/subway.log
  -[x] DNS 설정
    - http://subway.sixthou.kro.kr:8080/


---
## 🚀 2단계 - 서비스 배포하기
### 요구사항
- 운영 환경 구성하기
  - [x] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
    - [x] 외부망에 Nginx로 Reverse Proxy를 구성
      1. 도커설치
      2. 도커파일 작성
    - [x] Reverse Proxy에 TLS 설정
      1. 인증서 발급
      2. 도커파일 수정
      3. 443 포트 오픈
  - [x] 운영 데이터베이스 구성하기
    1. nat 게이트웨이 설정
    2. 도커설치
- 개발 환경 구성하기
  - [x] 설정 파일 나누기
    - JUnit : h2, Local : docker(mysql), Prod : 운영 DB를 사용하도록 설정

---
## 🚀 3단계 - 배포 스크립트 작성하기
### 요구사항
- [x] 배포 스크립트 작성하기   
- [x] crontab 설정

<br>
  
- 작업 파일 위치
  - 배포 스크립트 -> /home/ubuntu/app/deploy.sh
  - crontab 로그 -> /home/ubuntu/data/log/cron_log.log

<br>
  
- 배포 스크립트
  ```shell
  #!/bin/bash
  
  ## 변수 설정
  txtrst='\033[1;37m' # White
  txtred='\033[1;31m' # Red
  txtylw='\033[1;33m' # Yellow
  txtpur='\033[1;35m' # Purple
  txtgrn='\033[1;32m' # Green
  txtgra='\033[1;30m' # Gray
  
  PROJECT_PATH='/home/ubuntu/app/infra-subway-deploy'
  JAR_PATH=${PROJECT_PATH}/build/libs/
  LOG_PATH='/home/ubuntu/data/log/subway_log.log'
  EXECUTION_PATH=$(pwd)
  SHELL_SCRIPT_PATH=$(dirname $0)
  BRANCH=$1
  PROFILE=$2
  
  function findJar(){
      echo "$(find ${JAR_PATH} -name '*jar')"
  }
  
  function findPid(){
      echo "$(ps -ef | grep -v 'grep' | grep ${JAR_PATH}$1 | awk '{print $2}')"
  }
  
  function print() {
      echo -e "${txtgrn}>> $1 ${txtgrn}"
  }
  
  function pull() {
      print "${txtrst}Step1. pull request 🥚${txtrst}"
      cd ${PROJECT_PATH}
      print "$(pwd)"
      git pull origin ${BRANCH}
  }
  
  function build() {
      print "${txtrst}Step2. gradle build 🐣${txtrst}"
      cd ${PROJECT_PATH}
      ./gradlew clean build
  }
  
  function stop_process() {
      print "${txtrst}Step3. stop 🐥${txtrst}"
      PID=$(findPid);
      if [[ -n ${PID} ]]
      then
          print "${txtgrn}KILL SUCCESS : ${PID}${txtgrn}"
          kill ${PID}
      else
          print "${txtylw}실행중인 프로세스가 없습니다.${txtylw}"
      fi
  }
  
  function run() {
      print "${txtrst}Step4. run 🐓${txtrst}"
      JAR=$(findJar);
      sleep 5
      nohup java -jar -Dspring.profiles.active=${PROFILE} ${JAR} 1>> ${LOG_PATH} 2>&1 &
      PID=$(findPid);
      if [[ -n ${PID} ]]
      then
          print "${txtgrn}RUN SUCCESS PID : ${PID}${txtgrn}"
      else
          print "${txtred}RUN FAIL${txtred}"
      fi
  }
  
  function deploy(){
      pull;
      build;
      stop_process;
      run;
      exit
  }
  
  function check(){
      cd ${PROJECT_PATH}
      git fetch
      master=$(git rev-parse $BRANCH)
      remote=$(git rev-parse origin/$BRANCH)
  
      if [[ $master == $remote ]] 
      then
          echo -e "[$(date)] Nothing to do!!! 😫"
          exit 0
      else
          echo -e "${txtylw}=======================================${txtrst}"
          echo -e "${txtgrn}           << 배포 스크립트 🧐>>           ${txtrst}"
          echo -e ""
          echo -e "${txtgrn} 브랜치 : ${txtred}${BRANCH} ${txtgrn}, 프로파일 : ${txtred}${PROFILE}"
          echo -e "${txtylw}=======================================${txtrst}"
          deploy;
      fi
  }
  
  
  if [[ $# -eq 2 ]]
  then
      check;
      exit
  else
      echo -e "${txtylw}=======================================${txtrst}"
      echo -e "${txtred}         브랜치와 프로파일을 설정하세요        ${txtred}"
      echo -e "${txtylw}=======================================${txtrst}"
      exit
  fi
  ```
- crontab 설정
  <img width="488" alt="스크린샷 2022-11-25 오후 3 05 17" src="https://user-images.githubusercontent.com/20774279/203912038-045cc596-feab-4e48-82ab-5503c5b6a566.png">

