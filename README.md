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
- 대역 : 192.168.99.0/24
  - 외부망 서브넷(yzzzzun-public-a) : 192.168.99.0/26
  - 외부망 서브넷(yzzzzun-public-b) : 192.168.99.64/26
  - 내부망 서브넷(yzzzzun-private-a) : 192.168.99.128/27
  - 관리용 서브넷(yzzzzun-private-b) : 192.168.99.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://yzzzzun.kro.kr/

3. 베스천 서버에 접속을 위한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요

### 1단계 - 요구사항

#### 망 구성

- [x] VPC 생성
  - [x] CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성
- [x] Subnet 생성
  - [x] 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
  - [x] 내부망으로 사용할 Subnet : 32개씩 1개
  - [x] 관리용으로 사용할 Subnet : 32개씩 1개
- [x] Internet Gateway 연결
- [x] Route Table 생성
  - [x] 외부망에서 쓸 Route Table 설정
  - [x] 내부망에서 쓸 Route Table 설정
- [x] Security Group 설정
  - [x] 외부망
    - 전체 대역 : 8080 포트 오픈
    - 관리망 : 22번 포트 오픈
  - [x] 내부망
    - 외부망 : 3306 포트 오픈
    - 관리망 : 22번 포트 오픈
  - [x] 관리망
    - 자신의 공인 IP : 22번 포트 오픈
- [x] 서버 생성
  - [x] 외부망에 웹 서비스용도의 EC2 생성
  - [x] 내부망에 데이터베이스용도의 EC2생성
  - [x] 관리망에 베스쳔 서버용도의 EC2 생성
  - [x] 베스쳔 서버에 Session Timeout 600s 설정
  - [x] 베스쳔 서버에 Command 감시로그 설정

#### 웹 애플리케이션 배포

- [x] 외부망에 웹 애플리케이션을 배포
- [x] DNS설정

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : 
