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
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 
  - donghwani-public-a : 192.168.32.0/26
  - donghwani-public-b : 192.168.32.64/26
  - donghwani-internal : 192.168.32.160/27
  - dongwhani-private : 192.168.32.128/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : 3.39.66.208:8080(donghwani.p-e.kr:8080)

3. 베스천 서버에 접속을 위한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요  
   - donghwanipemRSA.pem

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://www.donghwani.p-e.kr/

---

### [추가] 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
```bash
#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

cd ~/infra-subway-deploy

echo -e ">>>>> git pull"
git pull origin step2


echo -e ">>>>> build"
./gradlew clean build

echo -e ">>>>> 파일이동"
cp /home/ubuntu/infra-subway-deploy/build/libs/*.jar ~/


echo -e ">>>>> restart"
PID=$(pgrep -f java)

echo ">>>>>>>> 현재 구동되고 있는 프로세스 ID  $PID"


kill -2 $PID

nohup java -jar -Dspring.profiles.active=prod *.jar
```
2. cronjob 설정을 공유해주세요.
