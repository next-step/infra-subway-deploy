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

### 🚀 0단계 - pem 키 생성하기
1. 생성한 pem키를 알려주세요.
  - KEY-loopstudy

2. 생성한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1RoA4f-90wqbKCpp9cpXtBAzcT_y83A4M)에 업로드해주세요
![img.png](img.png)

## 1단계 - 망 구성하기
### 요구사항
#### 망 구성
- [x] VPC 생성 
  - [x] CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성
- [x] Subnet 생성
  - [x] 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
  - [x] 내부망으로 사용할 Subnet : 32개씩 1개
  - [x] 관리용으로 사용할 Subnet : 32개씩 1개
- [x] Internet Gateway 연결
  - [x] VPC 연결 
- [x] Route Table 생성 
  - [x] IGW 연결용 라우팅 테이블 - 외부망 Subnet
  - [x] 내부망 라우팅 테이블 - 내부망 Subnet, 관리망 Subnet 
- [x] Security Group 설정
    - [x] 외부망 public
      - 전체 대역 : 8080 포트 오픈
      - 관리망 : 22번 포트 오픈 (관리망에 접근해야함)
    - [x] 내부망 internal
      - 외부망 : 3306 포트 오픈 (관리망과 외부망에서 접근)
      - 관리망 : 22번 포트 오픈 (관리망에 접근해야함)
    - [x] 관리망 bastion
      - 자신의 공인 IP : 22번 포트 오픈
- [x] 서버 생성 
  - [x] 외부망에 웹 서비스용도의 EC2 생성 
  - [x] 내부망에 데이터베이스용도의 EC2 생성
  - [x] 관리망에 베스쳔 서버용도의 EC2 생성 
    - [x] 내부망 접근을 위한 KEY 파일 복사  
  - [x] 베스쳔 서버에 Session Timeout 600s 설정
    - ~/.profile로 로그인한 유저만 설정하기
    - 서버 구분 추가 ~/.bashrc
  - [x] 베스쳔 서버에 Command 감사로그 설정 

#### 웹 애플리케이션 배포
- [x] 외부망에 웹 애플리케이션을 배포
  - [x] 외부망 a,b 환경세팅
  - [x] 외부망 a,b 깃허브 레포지토리 클론 및 빌드
  - [x] 애플리케이션 실행 확인
  - [x] 애플리케이션 로그 확인
- [x] DNS 설정
  - [x] 내도메인.한국으로 도메인 생성
  - [x] 외부망 연결 및 접속 확인 

1. 구성한 망의 서브넷 대역을 알려주세요
- 외부망1 : 192.168.8.0/26   (loopstudy-public-a)
- 외부망2 : 192.168.8.64/26  (loopstudy-public-b)
- 내부망  : 192.168.8.128/27 (loopstudy-private-db-a)
- 관리망  : 192.168.8.160/27 (loopstudy-bastion-a)

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요
- URL : http://www.loopstudy.p-e.kr:8080

3. 베스천 서버에 접속을 위한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요
- KEY-loopstudy
---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : 

---

### [추가] 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

2. cronjob 설정을 공유해주세요.
