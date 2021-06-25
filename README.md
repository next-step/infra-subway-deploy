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
- 대역 : 192.168.123.0/24
    * public 1 : 192.168.123.0/26
    * public 2 : 192.168.123.64/26
    * private 1 : 192.168.123.128/27
    * bastion 1 : 192.168.123.160/27
2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요
- URL : http://chae-yh-domain.kro.kr/
    * http://52.78.95.218:8080/
    * http://13.209.40.136:8080/
3. 베스천 서버에 접속을 위한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요
    * chae-yh-keypair.pem
    
#### 요구사항
* 웹 서비스를 운영할 네트워크 망 구성하기
    * VPC 생성
        * CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성 [O] -> chae-yh-vpc
    * Subnet 생성
        * 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성) [O] -> chae-yh-subnet-public-1 / chae-yh-subnet-public-2
        * 내부망으로 사용할 Subnet : 32개씩 1개 [O] -> chae-yh-subnet-private-1
        * 관리용으로 사용할 Subnet : 32개씩 1개 [O] -> chae-yh-subnet-public-3
    * Internet Gateway 연결 [O] -> chae-yh-internetgateway
    * Route Table 생성 [O] -> chae-yh-routingtable-public / chae-yh-routingtable-private
    * Security Group 설정 
        * 외부망 -> chae-yh-securitygroup-public
            * 전체 대역 : 8080 포트 오픈 [O]
            * 관리망 : 22번 포트 오픈 [O]
            * 전체 대역 : 80 포트 오픈 [O] -> DNS 설정 시 ip 매핑이 80번으로만 가능하여 해당 포트를 8080으로 포트포워딩함             
        * 내부망 -> chae-yh-securitygroup-private
            * 외부망 : 3306 포트 오픈 [O]
            * 관리망 : 22번 포트 오픈 [O]
        * 관리망 -> chae-yh-securitygroup-public-bastion
            * 자신의 공인 IP : 22번 포트 오픈 [O]
    * 서버 생성
        * 외부망에 웹 서비스용도의 EC2 생성 [O] -> chae-yh-ec2-public-1 / chae-yh-ec2-public-2
        * 내부망에 데이터베이스용도의 EC2 생성 [O] -> chae-yh-ec2-private-1-db
        * 관리망에 베스쳔 서버용도의 EC2 생성 [O] -> chae-yh-ec2-public-3-bastion
        * 베스쳔 서버에 Session Timeout 600s 설정 [O]
        * 베스쳔 서버에 Command 감사로그 설정 [O]
* 웹 애플리케이션 배포하기 
    * 외부망에 웹 애플리케이션을 배포 [O]
    * DNS 설정 [O]

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요
- URL : https://chae-yh-domain.kro.kr/

#### 요구사항
* 운영 환경 구성
    * 웹 애플리케이션 앞단에 Reverse Proxy 구성
        * 외부망에 Nginx로 Reverse Proxy를 구성 [O] -> chae-yh-ec2-public-4-reverseproxy
        * Reverse Proxy에 TLS 설정 [O]
    * 운영 데이터베이스 구성하기 [O] -> chae-yh-ec2-private-1-db(docker)
* 개발 환경 구성하기
    * 설정 파일 분리
        * JUnit : h2, Local : docker(mysql), Prod : 운영 DB를 사용하도록 설정 [O]
    * 데이터베이스 테이블 스키마 버전 관리 [O] -> flyway 사용 / tset, local 반영. prod 미반영
    * SonarLint 설정하기 [O] -> critical 로 나온 소스 수정하여 커밋
    * MultiRun 설정하기 [O]
    * 설정 별도 관리 [O]

