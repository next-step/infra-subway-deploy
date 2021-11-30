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
  - 외부망 1 : 192.168.13.0/26 (lewisseo91-subnet-public-a)
  - 외부망 2 : 192.168.13.64/26 (lewisseo91-subnet-public-b)
  - 내부망 : 192.168.13.128/27 (lewisseo91-subnet-private-a)
  - 관리망 : 192.168.13.160/27 (lewisseo91-subnet-admin-a)

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://step1.lewisseo91.p-e.kr/
  또는 : http://subway.lewisseo91.p-e.kr:8080/

3. 베스천 서버에 접속을 위한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요
  이름 : KEY-lewisseo91

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://subway.lewisseo91.p-e.kr/

### 1단계 체크 리스트

### 망구성

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
    - 전체 대역 : 8080 포트 오픈 
    - 관리망 : 22번 포트 오픈 
  - 내부망 
    - 외부망 : 3306 포트 오픈 
    - 관리망 : 22번 포트 오픈 
  - 관리망 
    - 자신의 공인 IP : 22번 포트 오픈 
- [x] 서버 생성 
  - [x] 외부망에 웹 서비스용도의 EC2 생성
  - [x] 내부망에 데이터베이스용도의 EC2 생성
  - [x] 관리망에 베스쳔 서버용도의 EC2 생성
  - [x] 베스쳔 서버에 Session Timeout 600s 설정
  - [x] 베스쳔 서버에 Command 감사로그 설정
  

### 겪은 이슈 정리

- port 22 session timeout (ssh 접속 시도)
  - 온갖 시도를 다 해 본 결과 
    기존 잘못된 생각 : host ip 를 대역으로 다 받아서 
      ex. 192.168.***.0/26 이라면 0~63 -> 대표 ip 해당 대역폭의 host ip로 자동 routing 이라는 어이없는 생각을 함.
    바른 생각 : ec2 instance에 생성된 private ip 를 확인하고 이를 통해 접속..
    
### 이해한 것

- subnet 등록 : 대역폭 나누기
- 라우팅 테이블 -> subnet 연결 : 어떤 subnet이 어떻게 라우팅 될 지 결정 (주소나 대역폭 범위)
- 인터넷 게이트웨이 -> vpc 등록 : vpc 범위에 들어오면 인터넷 게이트웨이를 거치게 된다
- 라우팅 테이블 -> 인터넷 게이트웨이 선택(대상) : 인터넷 게이트웨이에서 들어온 것을 라우팅 테이블에 적용한다는 의미 

---
  
### 웹 애플리케이션 배포

- [x] 외부망에 웹 애플리케이션을 배포 
- [x] DNS 설정

## 2단계 체크 리스트

### 운영 환경 구성하기

- [x] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
  - 외부망에 Nginx로 Reverse Proxy를 구성
  - Reverse Proxy에 TLS 설정
- [x] 운영 데이터베이스 구성하기

### 개발 환경 구성하기

- [x] 설정 파일 나누기 
  - JUnit : h2, Local : docker(mysql), Prod : 운영 DB를 사용하도록 설정
- [x] 데이터베이스 테이블 스키마 버전 관리 (flyway)

### 겪은 이슈 및 느낀점 정리 (2단계)

- TLS 설정 시 subdomain까지 같이 설정해 줘야 한다.
  - 예전에 nginx로 다른 곳에서 쓸 때는 mainDomain 이름만 넣고 했던 기억에 너무 의존하여 오랜 시간동안 디버깅 진행
    - 브라우저 메시지를 좀 더 정확하게 이해할 수 있게 되었다.
  
- Flyway의 편리함과 괴랄함을 동시에 느끼게 되었다.
  - 완전 세팅이 다 되어있을 시, 다음 버전 수정 시 많은 일을 할 필요가 없는 굉장한 툴
  - 하지만 초보가 세팅 시 syntax error 발생 -> transaction rollback 일어나지 않음 -> v1이 이상한 형태로 그대로 init 됨
    - 이를 해결하기 위해 flyway repair, sql 내에서 drop, delete 와 같은 행동들을 진행
    - 이와 같은 일이 실무에서 일어났다면 끔찍했을 것이라 생각
  - 실전에서 여러 유저가 사용할 때 이런 일이 발생한다면 flyway_schema_history log를 보고 rollback을 하면되지만 어떻게 할까라는 고민을 많이 하게 함.