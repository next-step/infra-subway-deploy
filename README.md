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
- key-earth-h.pem (기존 key가 삭제되어 신규 key를 업로드 하였습니다.)

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 
  - earth-h-public-subnet01 : 172.20.0.0/26
  - earth-h-public-subnet02 : 172.20.0.64/26
  - earth-h-private-subnet01 : 172.20.0.128/27
  - earth-h-admin-subnet01 : 172.20.0.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요
- URL : http://earth-h.tk:8080

#### 요구사항
**[ 망 구성 ]**
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
    - [x] 전체 대역 : 8080 포트 오픈
    - [x] 관리망 : 22번 포트 오픈 
  - 내부망
    - [x] 외부망 : 3306 포트 오픈
    - [x] 관리망 : 22번 포트 오픈
  - 관리망
    - [x] 자신의 공인 IP : 22번 포트 오픈
    - [x] 외부망/내부망 : 514 포트 오픈 -> rsyslog TCP 로그 원격으로 남기기 위함
서버 생성
  - [x] 외부망에 웹 서비스용도의 EC2 생성
    - 베스천 서버 접근 후 `ssh ubuntu@earth-h-web-service` 접근 가능
    - `/nextstep/project/infra-subway-deploy/`에 infra-subway-deploy 프로젝트 클론
  - [x] 내부망에 데이터베이스용도의 EC2 생성
    - 베스천 서버 접근 후 `ssh ubuntu@earth-h-db` 접근 가능
  - [x] 관리망에 베스쳔 서버용도의 EC2 생성
    - `ssh -i earth-h.pem ubuntu@43.201.95.83` 접근 가능
  - [x] 베스쳔 서버에 Session Timeout 600s 설정
  - [x] 베스쳔 서버에 Command 감사로그 설정
    - /var/log/command.log 내 외부망, 베스천, 내부망 서버 모두의 command 입력 로그 남김
* 주의사항
  다른 사람이 생성한 리소스는 손대지 말아요 🙏🏻
  모든 리소스는 태그를 작성합니다. 이 때 자신의 계정을 Prefix로 붙입니다. (예: brainbackdoor-public)
**[ 웹 애플리케이션 배포 ]**
- [x] 외부망에 웹 애플리케이션을 배포
- [x] DNS 설정

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://earth-h.tk

#### 요구사항
**[ 운영 환경 구성하기 ]**
- [x] 웹 어플리케이션 앞단에 reverse proxy 구성하기
  - [x] 외부망에 nginx로 reverse proxy 구성
  - [x] reverse proxy에 TLS 설정
- [x] 운영 데이터베이스 구성하기
**[ 개발 환경 구성하기 ]**
- [x] 설정 파일 나누기
  - JUnit: H2 -> application-test.yml
  - Local: docker(mysql) -> application-local.yml
  - Prod: 운영 DB 사용하도록 설정 -> application-prod.yml

#### 작업 내용
- nginx 설정 시, 로그를 서버 내에서 보고자 docker-compose 이용해 volumes 지정
  - dockerfile과 docker-compose 경로: `ssh ubuntu@earth-h-web-service` 접근 후 `cd /nextstep/sw/nginx/.` 내에 존재
    - nginx 로그 위치: /nextstep/sw/nginx/logs/access.log, error.log
  - docker-compose 사용 시, `docker-compose : Unsupported config option for services services: 'nginx'`에러가 발생하여서, docker-compose는 힌트에서 적힌 버전이 아닌 최신 버전 설치함
  ```bash
  sudo curl -L https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  ```
- http://earth-h.tk -> https://earth-h.tk 리다이렉트 설정
- AWS에 띄워둔 EC2 내에 fork한 레포지토리를 클론하여 현재 step의 yml을 가지고 prod 환경으로 어플리케이션 띄움
  - `nohup java -Dspring.profiles.active=prod -jar subway-0.0.1-SNAPSHOT.jar 1> /nextstep/log/202211190044.log 2>&1 &`
  - 어플리케이션 로그 위치: /nextstep/log/202211190044.log
- private subnet에 인터넷을 통해 docker를 설정하고자 NAT gateway 설정
  - 참고자료: https://www.linkedin.com/pulse/connecting-internet-from-ec2-instance-private-subnet-aws-thandra/
- 운영 DB에 어떤 database로 생성되어있는지 확인
  ```bash
  [DB][00:09:50][ubuntu@ip-172-20-0-152 ~] $ docker exec -it naughty_meitner bash
  root@948bd7b6557f:/# mysql -u root -p
  Enter password:
  ...
  mysql> show databases;
  +--------------------+
  | Database           |
  +--------------------+
  | information_schema |
  | mysql              |
  | performance_schema |
  | subway             |
  | sys                |
  +--------------------+
  5 rows in set (0.00 sec)
  
  mysql> use subway;
  Reading table information for completion of table and column names
  You can turn off this feature to get a quicker startup with -A
  
  Database changed
  mysql> show tables;
  +------------------+
  | Tables_in_subway |
  +------------------+
  | favorite         |
  | line             |
  | member           |
  | section          |
  | station          |
  +------------------+
  5 rows in set (0.00 sec)
  ```
---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.


