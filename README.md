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

- 외부망
    - `y2o2u2n-a` : `ap-northeast-2a`, `192.168.222.0/26`
    - `y2o2u2n-b` : `ap-northeast-2c`, `192.168.222.64/26`
- 내부망
    - `y2o2u2n-c` : `ap-northeast-2a`, `192.168.222.128/27`
- 관리용
    - `y2o2u2n-d` : `ap-northeast-2c`, `192.168.222.160/27`

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- 서비스 용도 EC2 첫번째 인스턴스 URL : http://3.37.179.45:8080/
- 서비스 용도 EC2 두번째 인스턴스 URL : http://54.180.71.34:8080/
- 서비스 용도 EC2 첫번째 인스턴스에 도메인 적용한 URL : http://y2o2u2n.p-e.kr:8080/

3. 베스천 서버에 접속을 위한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에
   업로드해주세요

---

### 2단계 - 배포하기

1. TLS가 적용된 URL을 알려주세요

- URL :

### 요구사항

#### 1단계 - 서비스 구성하기

##### 망 구성

- [x] VPC 생성
    - [x] CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성
        - [x] `y2o2u2n-vpc` : `192.168.222.0/24`
- [x] Subnet 생성
    - [x] 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
        - [x] `y2o2u2n-a` : `ap-northeast-2a`, `192.168.222.0/26`
        - [x] `y2o2u2n-b` : `ap-northeast-2c`, `192.168.222.64/26`
    - [x] 내부망으로 사용할 Subnet : 32개씩 1개
        - [x] `y2o2u2n-c` : `ap-northeast-2a`, `192.168.222.128/27`
    - [x] 관리용으로 사용할 Subnet : 32개씩 1개
        - [x] `y2o2u2n-d` : `ap-northeast-2c`, `192.168.222.160/27`
- [x] Internet Gateway 연결
    - [x] `y2o2u2n-igw` 생성
    - [x] `y2o2u2n-vpc` 연결
    - [x] `y2o2u2n-external-rt` 내 라우팅 편집에서 `0.0.0.0/0` 에는 `y2o2u2n-igw` 연결
- [x] Route Table 생성
    - [x] 외부망
        - [x] `y2o2u2n-external-rt` : `y2o2u2n-a`, `y2o2u2n-b`, `y2o2u2n-d`
    - [x] 내부망
        - [x] `y2o2u2n-internal-rt` : `y2o2u2n-c`
- [x] Security Group 설정
    - [x] 외부망 `SG-y2o2u2n-external`
        - [x] 전체 대역 : `8080` 포트 오픈
        - [x] 관리망 : `22` 포트 오픈
        - [x] 전체 대역 : ICMP 오픈
    - [x] 내부망 `SG-y2o2u2n-internal`
        - [x] 외부망 : `3306` 포트 오픈
        - [x] 관리망 : `22` 포트 오픈
        - [x] 전체 대역 : ICMP 오픈
    - [x] 관리망 `SG-y2o2u2n-bastion`
        - [x] 자신의 공인 IP : `22` 포트 오픈
        - [x] 전체 대역 : ICMP 오픈
- [x] 서버 생성
    - [x] 외부망에 웹 서비스용도의 EC2 생성
        - [x] AMI : `Ubuntu Server 18.04 LTS (HVM), SSD Volume Type`
        - [x] 인스턴스 : `t2.medium`
        - [x] VPC : `y2o2u2n-vpc`
        - [x] 서브넷 : 각각 `y2o2u2n-a`, `y2o2u2n-b`
        - [x] 태그 : `EC2-y2o2u2n`
        - [x] 보안 그룹 : `SG-y2o2u2n-external`
    - [x] 내부망에 데이터베이스용도의 EC2 생성
        - [x] AMI : `Ubuntu Server 18.04 LTS (HVM), SSD Volume Type`
        - [x] 인스턴스 : `t2.medium`
        - [x] VPC : `y2o2u2n-vpc`
        - [x] 서브넷 : `y2o2u2n-c`
        - [x] 태그 : `EC2-y2o2u2n`
        - [x] 보안 그룹 : `SG-y2o2u2n-internal`
    - [x] 관리망에 베스쳔 서버용도의 EC2 생성
        - [x] AMI : `Ubuntu Server 18.04 LTS (HVM), SSD Volume Type`
        - [x] 인스턴스 : `t2.medium`
        - [x] VPC : `y2o2u2n-vpc`
        - [x] 서브넷 : `y2o2u2n-d`
        - [x] 태그 : `EC2-y2o2u2n`
        - [x] 보안 그룹 : `SG-y2o2u2n-bastion`
    - [x] 베스쳔 서버에 Session Timeout 600s 설정
    - [x] 베스쳔 서버에 쉘 프롬프트 변경
    - [x] 베스쳔 서버에 Command 감사로그 설정
    - [x] 베스천 서버에서 서비스용 서버에 ssh 연결 설정
    - [x] 베스천 서버에서 다른 서버로 접근이 용이하도록 별칭 설정
- [x] Elastic IP 생성
    - [x] EIP-y2o2u2n-service-a : 서비스 용도 EC2 첫번째 인스턴스에 연결
    - [x] EIP-y2o2u2n-service-b : 서비스 용도 EC2 두번째 인스턴스에 연결
    - [x] EIP-y2o2u2n-database : 데이터베이스 용도 EC2 인스턴스에 연결
    - [x] EIP-y2o2u2n-bastion : 베스쳔 용도 EC2 인스턴스에 연결

##### 웹 애플리케이션 배포

- [x] 외부망에 웹 애플리케이션을 배포
    - [x] 서비스 용도 EC2 두 인스턴스에 배포
- [x] DNS 설정
    - [x] y2o2u2n.p-e.kr 에 서비스 용도 EC2 첫번째 인스턴스 IP에 연결
        - [x] http://y2o2u2n.p-e.kr:8080/

#### 2단계 - 서비스 배포하기

- [x] 도커 설치
    - [x] 서비스 용도 EC2 2개
    - [x] 데이터베이스 용도 EC2 1개
- [ ] 운영 환경 구성하기
    - [ ] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
        - [x] 외부망에 Nginx로 Reverse Proxy를 구성
            - [x] Nginx와 App의 `Dockerfile` 작성
            - [x] Gradle 빌드 후 Docker 빌드하는 `build.sh` 작성 
            - [x] Nginx와 App을 띄우는 Docker Compose 구성
        - [ ] Reverse Proxy에 TLS 설정
    - [x] 운영 데이터베이스 구성하기
        - [x] 컨테이너 실행 : `docker run -d -p 3306:3306 brainbackdoor/data-subway:0.0.1`
- [ ] 개발 환경 구성하기
    - [ ] 설정 파일 나누기
        - [ ] JUnit : h2, Local : docker(mysql), Prod : 운영 DB를 사용하도록 설정
    - [ ] 데이터베이스 테이블 스키마 버전 관리
