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
* [x] 완료
2. 업로드한 pem키는 무엇인가요.
* KEY-yoonmin-kim.pem
### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- yoonmin-kim-internal-a : 192.168.94.128/27
- yoonmin-kim-bastion-c : 192.168.94.160/27
- yoonmin-kim-public-c : 192.168.94.64/26
- yoonmin-kim-public-a : 192.168.94.0/26

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://www.yoonmin-kim.r-e.kr:8080/



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://www.yoonmin-kim.r-e.kr/

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
- check_df.sh 를 1분마다 동작하도록 크론탭으로 등록하였습니다.
- 마스터 브랜치와 리모트 브랜치를 비교하여 변경이 발생했을 경우 deploy.sh 를 실행합니다.
  - /home/ubuntu/nextstep/log/crontab_log.txt 에 크론탭 수행 로그가 남겨집니다.
  - /home/ubuntu/nextstep/log/check_df_log.txt 에 check_df.sh 수행 로그가 남겨집니다.
- deploy.sh 에는 각 동작별로 함수로 작성하였습니다.
- git pull 을 수행한 뒤 빌드 및 배포를 진행합니다.
  - /home/ubuntu/nextstep/log/application.log 에 nohup 명령어 로그가 남겨집니다.

배포 스크립트 경로:
- yoonmin-kim-public-EC2-a(192.168.94.32) 접속
- /home/ubuntu/nextstep/check_df.sh
- /home/ubuntu/nextstep/deploy.sh

   
