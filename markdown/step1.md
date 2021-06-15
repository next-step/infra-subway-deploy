# 🚀 1단계 - 서비스 구성하기

## 요구사항

1. 구성한 망의 서브넷 대역을 알려주세요
   - 대역 :

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요
   - URL :

3. 베스천 서버에 접속을 위한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요

### 망 구성

- [X] VPC 생성
  - [X] CIDR은 C class(192.168.102.0/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성
- [X] Subnet 생성
  - [X] 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
    - [X] mskangg-external1
    - [X] mskangg-external2
  - [X] 내부망으로 사용할 Subnet : 32개씩 1개
    - [X] mskangg-internal1
  - [X] 관리용으로 사용할 Subnet : 32개씩 1개
    - [X] mskangg-admin1
- [X] Internet Gateway 연결
- [X] Route Table 생성
  - [X] 외부망 mskangg-expternal-rt
  - [X] 내부망 mskangg-internal-rt
  - [X] 관리망 mskangg-admin-rt
- [X] Security Group 설정
  - [X] 외부망
    - [X] 전체 대역 : 8080 포트 오픈
    - [X] 관리망 : 22번 포트 오픈
  - [X] 내부망
    - [X] 외부망 : 3306 포트 오픈
    - [X] 관리망 : 22번 포트 오픈
  - [X] 관리망
    - [X] 자신의 공인 IP : 22번 포트 오픈
- [ ] 서버 생성
  - [ ] 외부망에 웹 서비스용도의 EC2 생성
  - [ ] 내부망에 데이터베이스용도의 EC2 생성
  - [ ] 관리망에 베스쳔 서버용도의 EC2 생성
  - [ ] 베스쳔 서버에 Session Timeout 600s 설정
  - [ ] 베스쳔 서버에 Command 감사로그 설정

### 웹 애플리케이션 배포

- [ ] 외부망에 웹 애플리케이션을 배포
- [ ] DNS 설정
