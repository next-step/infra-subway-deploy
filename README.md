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

- [X] 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
    - subnet name : `wooobo-service-subnet-2a`
        - `subnet-0f6b330d813295497` : `가용영역: ap-northeast-2a`, `IPv4 CIDR : 192.168.240.0/26`
    - subnet name : `wooobo-service-subnet-2c`
        - `subnet-0190e70fcd0469fe1` : `가용영역: ap-northeast-2c`, `IPv4 CIDR : 192.168.240.64/26`
- [X] 내부망으로 사용할 Subnet : 32개씩 1개
    - subnet name : `wooobo-internal-subnet`
        - `subnet-0c9578dd48c53ec7e` : `가용영역: ap-northeast-2a`, `IPv4 CIDR : 192.168.240.128/27`
- [X] 관리용으로 사용할 Subnet : 32개씩 1개
    - subnet name : `wooobo-manage-subnet`
        - `subnet-00ee06c1454238765` : `가용영역: ap-northeast-2c`, `IPv4 CIDR : 192.168.240.160/27`

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL :
    - http://wooobo.p-e.kr
    - 웹 서비스 서버 고정 IP : 3.38.13.29

3. 베스천 서버에 접속을 위한  
   pem 파일 이름 : wooobo-nextstep.pem

---

### 2단계 - 배포하기

1. TLS가 적용된 URL을 알려주세요

- URL : https://wooobo.p-e.kr

### 미션 수행 작성

#### 1단계

- [X] VPC
    - `Name : wooobo-vpc`
    - `Ipv4 CIDR : 192.168.240.0/24`
- [X] Internet Gateway 연결
    - `Name : wooobo-igw`
- [X] Route Table 생성
    - wooobo-rt (외부연결)
        - 라우팅 대상 : `local`, `igw-01d17b7517e23b927`
        - 서브넷 : `wooobo-service-subnet-2a`, `wooobo-service-subnet-2c`, `wooobo-manage-subnet`
    - wooobo-internal-rt (내부)
        - 라우팅 대상 : `local`
        - 서브넷 : `wooobo-internal-subnet`
- Security Group 설정
    - [X] 관리망
        - `Name : wooobo-manage-SG ( sg-0a8df29057748ee7d )`
        - `Port : 22`, `Source : 210.204.220.172/32 (집 IP)`
    - [X] 외부망
        - `Name : wooobo-SG ( sg-013e2ec7d2b512f5b )`
        - `Port : 22` , `Source : sg-0a8df29057748ee7d (관리망)`
        - `Port : 80`, `Source :  0.0.0.0/0 (전체대역)`
        - `Port : 8080`, `Source :  0.0.0.0/0 (전체대역)`
    - [X] 내부망
        - `Name : wooobo-internal-SG ( sg-07d1effb8f91cfcc9 )`
        - `Port : 22` , `Source : sg-0a8df29057748ee7d (관리망)`
        - `Port : 3306`, `Source : sg-013e2ec7d2b512f5b (외부망)`
- 서버 생성하기(EC2)
    - [X] 관리망에 베스쳔 서버용도의 EC2 생성
        - `Name : EC2-wooobo-bastion`
        - `인스턴스 ID : i-0f2c87cb4058382e1`
        - `서브넷 : subnet-00ee06c1454238765 (wooobo-manage-subnet)`
        - `보안그룹 : sg-0a8df29057748ee7d (wooobo-manage-SG)`
    - [X] 외부망에 웹 서비스용도의 EC2 생성
        - `Name : EC2-wooobo-web-service`
        - `인스턴스 ID : i-01cf2a40ad72b0492`
        - `서브넷 :  subnet-0f6b330d813295497 (wooobo-service-subnet-2a) (igw 연결됨)`
        - `보안그룹 : sg-013e2ec7d2b512f5b (wooobo-SG) (외부망)`
        - 80포트포워딩(`sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080`)
    - [X] 내부망에 데이터베이스용도의 EC2 생성
        - `Name : EC2-wooobo-database`
        - `인스턴스 ID : i-00087fb6b5246f098`
        - `서브넷 :  subnet-0c9578dd48c53ec7e (wooobo-internal-subnet)`
        - `보안그룹 : sg-07d1effb8f91cfcc9 (wooobo-internal-SG) (내부망)`
- 서버 설정하기
    - 베스쳔 서버에 Session Timeout 600s 설정
    - 베스쳔 서버에 Command 감사로그 설정
        - `/var/log/command.log`
    - 서비스용 서버에 `authorized_keys` 추가
    - 베스천서버 -> 웹서비스 접속 커맨드 : `$ ssh ubuntu@webService`
    - 베스천서버 -> 데이터베이스 접속 커맨드 : `$ ssh ubuntu@database`
    - shell prompt 변경하기
- [X] 웹 애플리케이션 배포
- [X] DNS 설정

#### 2단계 - 서비스 배포하기

- [X] 운영 환경 구성하기
- [X] 개발 환경 구성하기
- [X] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
    - [X] 외부망에 Nginx로 Reverse Proxy를 구성
    - [X] Reverse Proxy에 TLS 설정
- [X] 운영 데이터베이스 구성하기

- 개발 환경 구성하기
    - [X] 설정 파일 나누기
        - [X]  JUnit : h2, Local : docker(mysql), Prod : 운영 DB를 사용하도록 설정
    - [X] 데이터베이스 테이블 스키마 버전 관리

##### properties git submodule 커멘드
```shell
$ git submodule add git@github.com:wooobo/wooobo-nextstep-private-repo.git ./src/main/resources/config
$ git clone --recurse-submodules git@github.com:wooobo/wooobo-nextstep-private-repo.git
$ git submodule update --init
```
#### 서버 실행
```shell
# 빌드
./gradlew clean build
# jar파일을 찾아본다.
$ find ./* -name "*jar"
# 서버시작 : 
$ java -jar -Dspring.profiles.active=prod  ./build/libs/subway-0.0.1-SNAPSHOT.jar &
# 서버백그라운드 실행 :
$ nohup java -jar -Dspring.profiles.active=prod  ./build/libs/subway-0.0.1-SNAPSHOT.jar  1> ../nohup.log 2>&1  &

```