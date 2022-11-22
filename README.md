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

1. 서버에 접속을 위한 pem키를 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에
   업로드해주세요

2. 업로드한 pem키는 무엇인가요.

- ilmare-cbk.cer

### 1단계 - 망 구성하기

1. 구성한 망의 서브넷 대역을 알려주세요

- 대역 :
    - ilmare-cbk-public-subnet-01 : 192.168.30.0/26
    - ilmare-cbk-public-subnet-02 : 192.168.30.64/26
    - ilmare-cbk-private-subnet : 192.168.30.128/27
    - ilmare-cbk-admin-subnet : 192.168.30.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://ilmare-cbk-subway.kro.kr:8080

#### 요구사항

망구성

- [x] VPC 생성
    - CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성

- [x] Subnet 생성
    - 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
    - 내부망으로 사용할 Subnet : 32개씩 1개
    - 관리용으로 사용할 Subnet : 32개씩 1개

- [x] Internet Gateway 연결

- [x] Route Table 생성

- [x] Security Group 설정
    - 외부망
        - [x] 전체 대역 : 8080 포트 오픈
        - [x] 관리망 : 22번 포트 오픈
    - 내부망
        - [x] 외부망 : 3306 포트 오픈
        - [x] 관리망 : 22번 포트 오픈
    - 관리망
        - [x] 자신의 공인 IP : 22번 포트 오픈

- [x] 서버 생성
    - [x] 외부망에 웹 서비스용도의 EC2 생성
    - [x] 내부망에 데이터베이스용도의 EC2 생성
    - [x] 관리망에 베스쳔 서버용도의 EC2 생성
    - [x] 베스쳔 서버에 Session Timeout 600s 설정
    - [x] 베스쳔 서버에 Command 감사로그 설정

웹 애플리케이션 배포

- [x] 외부망에 웹 애플리케이션 배포
- [x] DNS 설정

---

### 2단계 - 배포하기

1. TLS가 적용된 URL을 알려주세요

- URL : https://ilmare-cbk-subway.kro.kr

#### 요구사항

운영 환경 구성하기

- [x] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
    - [x] 외부망에 Nginx로 Reverse Proxy를 구성
    - [x] Reverse Proxy에 TLS 설정
- [x] 운영 데이터베이스 구성하기

개발 환경 구성하기

- [x] 설정 파일 나누기
    - [x] JUnit : h2
    - [x] Local : docker(mysql)
    - [x] Prod : 운영 DB를 사용하도록 설정

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

- `/home/ubuntu/nextstep/script` 경로에 스크립트가 있습니다.
- `/home/ubuntu/nextstep/log` 경로에 `app.log` 파일로 로그를 기록하고 있습니다.
- `setting.sh`
    - 여러 스크립트에서 공통으로 사용하는 변수와 함수를 정의해두었습니다.
    - find_jar -> jar 명 출력
    - find_pid -> PID 출력
    ```shell
    #!/bin/bash
    
    ## set variable
    
    PROJECT_PATH='/home/ubuntu/nextstep/infra-subway-deploy'
    JAR_PATH=${PROJECT_PATH}/build/libs
    APP_LOG_PATH='/home/ubuntu/nextstep/log'
    
    find_jar() {
            echo "$(cd ${JAR_PATH} && find ./* -name "*jar" | cut -c 3-)"
    }
    
    
    find_pid() {
            JAR=$(find_jar)
            echo "$(ps -ef | grep $JAR | grep -v grep | awk '{print $2}')"
    }
    ```
- `stop.sh`
    - 현재 실행중인 프로세스를 종료시킵니다.
    ```shell
    #!/bin/bash
    
    . ./setting.sh
    
    echo ""
    echo ">> Stop Process 🏃♂️ "
    echo ""
    
    JAR_NAME=$(find_jar)
    PID=$(find_pid)
    
    
    if [ -z "$PID" ]; then
            echo "프로세스가 실행중이지 않습니다."
    else
            echo "$JAR_NAME의 프로세스를 종료합니다. (PID = $PID)"
            kill $PID
    fi
    ```
- `deploy.sh`
    - pull, build, stop_process, start_process 과정을 거쳐 서버를 띄웁니다.
  ```shell
  #!/bin/bash
  
  . /home/ubuntu/nextstep/script/setting.sh
  ## 변수 설정
  
  txtrst='\033[1;37m' # White
  txtred='\033[1;31m' # Red
  txtylw='\033[1;33m' # Yellow
  txtpur='\033[1;35m' # Purple
  txtgrn='\033[1;32m' # Green
  txtgra='\033[1;30m' # Gray
  
  ## script parameter
  BRANCH=$1
  
  ## guide
  guide() {
          echo "${txtgra}===============================================================${txtrst}"
          echo "${txtrst}              << This is a manual for deploy 😃 >>             ${txtrst}"
          echo "${txtrst}           This script need a parameter branch name.           ${txtrst}"
          echo "${txtrst}                   ex) sh deploy.sh step3                      ${txtrst}"
          echo "${txtgra}===============================================================${txtrst}"
  }
  
  ## pull
  pull() {
          echo ""
          echo ">> Pull Request 🏃♂️ "
          echo ""
          cd ${PROJECT_PATH} && git pull origin ${BRANCH}
  }
  
  ## build
  build() {
      echo ""
      echo ">> Build Project 🏃♂️ "
      echo ""
      cd ${PROJECT_PATH} && ./gradlew clean build
  }
  
  ## stop process
  stop_process() {
      JAR_NAME=$(cd ${JAR_PATH} && find ./* -name "*jar" | cut -c 3-)
      PID=$(ps -ef | grep $JAR_NAME | grep -v grep | awk '{print $2}')
  
      if [ -n "$PID" ]; then
          echo ""
          echo ">> Stop running process 🏃♂️ "
          echo ""
          kill $PID
      fi
  }
  
  ## start process
  start_process() {
      echo ""
      echo ">> Start Process 🏃♂️ "
      echo ""
  
      nohup java -jar -Dspring.profiles.active=prod $JAR_PATH/$JAR_NAME 1> $APP_LOG_PATH/app.log 2>&1 &
  }
  
  ## deploy
  deploy() {
      pull;
      build;
      stop_process;
      start_process;
  }
  
  ## check
  check() {
  
      PID=$(find_pid)
  
      if [ -z "$PID" ]; then
      deploy;
      exit 0
      fi
  
      cd ${PROJECT_PATH} && git fetch
      master=$(cd ${PROJECT_PATH} && git rev-parse ${BRANCH})
      remote=$(cd ${PROJECT_PATH} && git rev-parse origin/${BRANCH})
  
      if [ "$master" = "$remote" ]; then
      echo "[$(date)] Nothing to do!!! 😢"
          exit 0
      else
          deploy;
      fi
  }
  
  
  if [ -n "$BRANCH" ]; then
      check;
  else
      guide;
  fi
  ```

- crontab 설정
    - */60 * * * * /home/ubuntu/nextstep/script/deploy.sh step3 >> /home/ubuntu/nextstep/log/deploy.log 2>&1
