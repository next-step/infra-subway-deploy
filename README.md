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

1. 서버에 접속을 위한
   pem키를 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)
   에 업로드해주세요

2. 업로드한 pem키는 무엇인가요.  
   : `orgojy-nextstep-infra.pem`

### 1단계 - 망 구성하기

- VPC
    - "orgojy-vpc" C-class(192.168.17.0/24)
- Subnet
    - public (webservice)
        - "orgojy-public-a" ap-northeast-2a 192.168.17.0/26
        - "orgojy-public-b" ap-northeast-2b 192.168.17.64/26
    - private (db)
        - "orgojy-private-a" ap-northeast-2a 192.168.17.128/27
    - admin (bastion)
        - "orgojy-admin-a" ap-northeast-2a 192.168.17.160/27
- Internet Gateway
    - "orgojy-igw"
- NAT Gateway
    - "orgojy-nat"
- Route Table
    - orgojy-public-rt
        - 0.0.0.0/0 "orgojy-igw"
        - 192.168.17.0/24 local
    - orgojy-private-rt
        - 0.0.0.0/0 "orgojy-nat"
        - 192.168.17.0/24 local
    - orgojy-admin-rt
        - 0.0.0.0/0 "orgojy-igw"
        - 192.168.17.0/24 local
- Security Group
    - 외부망 "SG-orgojy-public"
        - OPEN: Port 8080, IP Anywhere(0.0.0.0/0)
        - OPEN: Port 22, IP 관리망(192.168.17.160/27)
    - 내부망 "SG-orgojy-private"
        - OPEN: Port 3306, IP 외부망(192.168.17.64/26, 192.168.17.0/26)
        - OPEN: Port 22, IP 관리망(192.168.17.160/27)
    - 관리망 "SG-orgojy-admin"
        - OPEN: Port 22, IP My Public IP
- EC2 Instance
    - 외부망에 웹 서비스용도의 EC2 생성 "orgojy-public-webservice"
    - 내부망에 데이터베이스용도의 EC2 생성 "orgojy-private-db"
    - 관리망에 베스쳔 서버용도의 EC2 생성 "orgojy-admin-bastion"
        - 베스쳔 서버에 Session Timeout 600s 설정
        - 베스쳔 서버에 Command 감사로그 설정

1. 구성한 망의 서브넷 대역을 알려주세요

- Subnet 대역 :
    - public (webservice)
        - "orgojy-public-a" ap-northeast-2a 192.168.17.0/26
        - "orgojy-public-b" ap-northeast-2b 192.168.17.64/26
    - private (db)
        - "orgojy-private-a" ap-northeast-2a 192.168.17.128/27
    - admin (bastion)
        - "orgojy-admin-a" ap-northeast-2a 192.168.17.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://orgojy.ga:8080
- Public IP : 3.39.99.54:8080

---

### 2단계 - 배포하기

1. TLS가 적용된 URL을 알려주세요

- URL : https://orgojy.ga

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

- 통합 실행 스크립트:
    - `scripts/main.sh`
    - ex) /home/ubuntu/nextstep/infra-subway-deploy/scripts/main.sh step3 prod ./build/libs/subway-0.0.1-SNAPSHOT.jar
- 구성 스크립트 :
    - `scripts/preprocess.sh` : 먼저 생성되어야하는 디렉토리나 파일 생성 목적
    - `scripts/shutdown.sh` : 기존에 생성되었던 프로세스 종료 목적
    - `scripts/start.sh` : 새롭게 애플리케이션 실행 목적

--- 

## 요구사항

### 0단계 - pem 키 생성하기

- [x] pem 키 생성하기
- [x] 리뷰 요청 프로세스 에 따라 리뷰 요청

### 1단계 - 망 구성하기

- [x] 웹 서비스를 운영할 네트워크 망 구성하기
    - [x] VPC 생성
        - [x] CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성
    - [x] Subnet 생성
        - [x] 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
        - [x] 내부망으로 사용할 Subnet : 32개씩 1개
        - [x] 관리용으로 사용할 Subnet : 32개씩 1개
    - [x] Internet Gateway 연결
    - [x] Route Table 생성
    - [x] Security Group 설정
        - [x] 외부망
            - [x] 전체 대역 : 8080 포트 오픈
            - [x] 관리망 : 22번 포트 오픈
        - [x] 내부망
            - [x] 외부망 : 3306 포트 오픈
            - [x] 관리망 : 22번 포트 오픈
        - [x] 관리망
            - [x] 자신의 공인 IP : 22번 포트 오픈
    - [x] 서버 생성
        - [x] 외부망에 웹 서비스용도의 EC2 생성
        - [x] 내부망에 데이터베이스용도의 EC2 생성
        - [x] 관리망에 베스쳔 서버용도의 EC2 생성
        - [x] 베스쳔 서버에 Session Timeout 600s 설정
        - [x] 베스쳔 서버에 Command 감사로그 설정
- 주의사항
    - 다른 사람이 생성한 리소스는 손대지 말아요 🙏🏻
    - 모든 리소스는 태그를 작성합니다. 이 때 자신의 계정을 Prefix로 붙입니다. (예: brainbackdoor-public)
- [x] 웹 애플리케이션 배포하기
    - [x] 외부망에 [웹 애플리케이션](https://github.com/next-step/infra-subway-deploy)을 배포
    - [x] DNS 설정

### 2단계 - 배포하기

- [x] 운영 환경 구성하기
    - [x] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
        - [x] 외부망에 Nginx로 Reverse Proxy를 구성
        - [x] Reverse Proxy에 TLS 설정
    - [x] 운영 데이터베이스 구성하기
- [x] 개발 환경 구성하기
    - [x] 설정 파일 나누기
        - [x] JUnit : h2, Local : docker(mysql), Prod : 운영 DB를 사용하도록 설정

### 3단계 - 배포 스크립트 작성하기

- [x] 배포 스크립트 작성하기
    - 아래 내용을 모두 반영할 필요는 없습니다.
    - 반복적으로 실행하더라도 정상적으로 배포하는 스크립트를 작성해봅니다.
