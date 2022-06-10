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

2. 업로드한 pem키 : KEY-handh0413.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 192.168.30.0/24 (handh0413-vpc)
    - 외부망 : 192.168.30.0/26 (handh0413-public-a)
    - 외부망 : 192.168.30.64/26 (handh0413-public-c)
    - 내부망 : 192.168.30.128/27 (handh0413-internal-a)
    - 관리망 : 192.168.30.160/27 (handh0413-management-c)

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요
- URL : https://handh.kro.kr
- IP : 15.164.66.164

3. EC2 인스턴스
- APPLICATION : handh0413-public-application01-EC2
- DATABASE : handh0413-internal-database-EC2
- BASTION : handh0413-management-bastion-EC2

4. 보안 그룹
- 외부망 : handh0413-public-SG
- 내부망 : handh0413-internal-SG	
- 관리망 : handh0413-management-SG

5. 망 구성
- [x] VPC 생성
    - CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성
- [x] Subnet 생성
    - [x] 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
    - [x] 내부망으로 사용할 Subnet : 32개씩 1개
    - [x] 관리용으로 사용할 Subnet : 32개씩 1개
- [x] Internet Gateway 연결
- [x] Route Table 생성
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
    - [x] 내부망에 데이터베이스용도의 EC2 생성
    - [x] 관리망에 베스쳔 서버용도의 EC2 생성
    - [x] 베스쳔 서버에 Session Timeout 600s 설정
    - [x] 베스쳔 서버에 Command 감사로그 설정

6. 웹 애플리케이션 배포
- [x] 외부망에 웹 애플리케이션을 배포
- [x] DNS 설정

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://handh.kro.kr

2. 운영 환경 구성하기

- [x] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
    - [x] 외부망에 Nginx로 Reverse Proxy를 구성
    - [x] Reverse Proxy에 TLS 설정
- [x] 운영 데이터베이스 구성하기

3. 개발 환경 구성하기

- [x] DB 연계 환경
    - [x] JUnit : h2
    - [x] Local : docker(mysql)
    - [x] Prod : docker(mysql)
    
- [x] 설정 파일 나누기
    - [x] 공통 : application.properties
    - [x] 로컬 : application-local.properties
    - [x] 운영 : application-prod.properties
    - [x] Junit 테스트 : application-test.properties
    
- [x] 실행 프로그램
    - [x] 외부망 : NginX(Docker) / SpringBoot  
    - [x] 내부망 : MySQL(Docker)
    
- [x] 설정 별도로 관리하기 (리뷰를 위한 private 아닌 public 저장소로 생성...)
    - [x] 서브 모듈 : https://github.com/handh0413/infra-subway-deploy-config.git
    - [x] 이후에 저장소를 가져올 때 서브 모듈까지 클론 (git clone --recurse-submodules)

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

- [x] 배포 스크립트 작성 (deploy.sh) 

