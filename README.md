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
- KEY-sanhee.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 
- sanhee-public-a: `192.192.192.0/26`
- sanhee-public-c: `192.192.192.64/26`
- sanhee-admin-a: `192.192.192.160/27`
- sanhee-internal-a: `192.192.192.128/27`

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : https://sanoeul.kro.kr/



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://sanoeul.kro.kr/

**운영 환경 구성하기**
- [X] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
    - [X] 외부망에 Nginx로 Reverse Proxy를 구성
    - [X] Reverse Proxy에 TLS 설정
- [X] 운영 데이터베이스 구성하기

**개발 환경 구성하기**
- [X] 설정 파일 나누기
- [X] JUnit : h2, Local : docker(mysql), Prod : 운영 DB를 사용하도록 설정

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

./script/deploy.sh

```shell
#!/bin/bash

APP_NAME='subway'
BRANCH='origin/step3'
PROFILE='prod'
EXECUTION_PATH=$(dirname $(dirname $(readlink -fm $0)))

moveDir(){
  echo "[$(date)] 디렉토리 이동"
  cd $EXECUTION_PATH
}

checkChangedDiff(){
  echo "[$(date)] 변경사항 체크"
  git fetch
  LOCAL=`git rev-parse HEAD`
  REMOTE=`git rev-parse $BRANCH`

  if [[ $LOCAL == $REMOTE ]]
  then
      echo "[$(date)] 변경사항이 없습니다. 😫"
      exit 0
  else
      exitApplication
      pull
      startBuild
      runApp
  fi
}

exitApplication(){
  echo "[$(date)] 저장소 변경사항이 생겨, 스프링 애플리케이션을 종료합니다."
        PID=$(jps | grep $APP_NAME | awk '{print $1}')
        kill -9 $PID
}

pull(){
  echo -e ""
  echo -e "[$(date)] >> git pull 🏃♂️"
  git pull origin main
}

startBuild(){
  echo "[$(date)] 빌드 시작"
  ./gradlew clean build
}

runApp(){
  echo -e "[$(date)] >> 애플리케이션 실행"
  JAR_FILE=`find ./build/* -name "*jar"`
  nohup java -jar -Dspring.profiles.active=${PROFILE} $JAR_FILE &
}

moveDir
checkChangedDiff
```
