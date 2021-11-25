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
    - 외부망 
        - 192.148.0.0/26
        - 192.148.0.64/26
    - 내부망
        - 192.148.0.128/27
    - 관리망
        - 192.148.0.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요
- URL : http://keepbang-woocamp.p-e.kr/, http://54.180.1.82:8000

3. 베스천 서버에 접속을 위한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요
- keepbang.pem으로 업로드 했습니다.
---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : 

## 작업 목록
- [X] VPC 생성
    - CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성
- [X] Subnet 생성
    - 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
    - 내부망으로 사용할 Subnet : 32개씩 1개
    - 관리용으로 사용할 Subnet : 32개씩 1개
- [X] Internet Gateway 연결
- [X] Route Table 생성
- Security Group 설정
    - [X] 외부망
        - 전체 대역 : 8080 포트 오픈
        - 관리망 : 22번 포트 오픈
    - [X] 내부망 
        - 외부망 : 3306 포트 오픈
        - 관리망 : 22번 포트 오픈
    - [X] 관리망
        - 자신의 공인 IP : 22번 포트 오픈
- [X] 서버 생성
    - [X] 외부망에 웹 서비스용도의 EC2 생성
    - [X] 내부망에 데이터베이스용도의 EC2 생성
    - [X] 관리망에 베스쳔 서버용도의 EC2 생성
    - [X] 베스쳔 서버에 Session Timeout 600s 설정
    - [X] 베스쳔 서버에 Command 감사로그 설정
    
- [X] 외부망에 웹애플리케이션 배포
- [ ] dns설정

인적장애 예방은 왜하는가?
