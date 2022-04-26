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
   : KEY-dibtp1221.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 
  외부망1 192.168.123.0/26   dibtp1221-a ap-northeast-2b
  외부망2 192.168.123.64/26  dibtp1221-b ap-northeast-2d
  내부망  192.168.123.128/27 dibtp1221-c ap-northeast-2b
  관리망  192.168.123.160/27 dibtp1221-d ap-northeast-2d

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://dibtp1221.kro.kr:8080/



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://dibtp1221.kro.kr/

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

- script/deploy.sh  
    ./script/deploy.sh {profile}  
    profile 기본값 prod  
    ex) ./script/deploy.sh local  
- script/log.sh  
    crontab으로 매일 23시 59분 (지금 설정된 서버시간으로 14:59) 에  
    서버로그 백업하고 subway_20220425_145901, 새로 만드는걸로 했습니다. (nohup rotation)  
    ```shell
    ubuntu@ip-192-168-123-60:~/nextstep/infra-subway-deploy$ crontab -l
    59 14 * * * /home/ubuntu/nextstep/infra-subway-deploy/script/log.sh
    ```

