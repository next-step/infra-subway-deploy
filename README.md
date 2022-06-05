# 그럴듯한 서비스 만들기 - 지하철 노선도
## 요구사항
- [x] VPC 생성  
    - CIDR 은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성
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
    - [x] 베스쳔 서버에 Command 감시로그 설정
- [x] 웹 어플리케이션 배포
    - [x] 외부망에 웹 어플리케이션 배포
    - [x] DNS 설정
- [ ] 운영 환경 구성하기
    - [ ] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
        - [ ] 외부망에 Nginx로 Reverse Proxy를 구성
        - [ ] Reverse Proxy에 TLS 설정
        - [ ] 운영 데이터베이스 구성하기
- [ ] 개발 환경 구성하기
    - [ ] 설정 파일 나누기
        - JUnit : h2, Local : docker(mysql), Prod : 운영 DB를 사용하도록 설정 
---
### 0단계 - pem 키 생성하기
1. 서버에 접속을 위한 pem 키를 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요
2. 업로드한 pem 키는 무엇인가요.
- pem 키 : key-iamjunsulee.pem
---
### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요.
- 대역: 
    - vpc
        - 192.168.24.0/24
    - 외부망
        - 192.168.24.0/26(iamjunsulee-public-1, ap-northeast-2a)
        - 192.168.24.64/26(iamjunsulee-public-2, ap-northeast-2c)
    - 내부망
        - 192.168.24.128/27(iamjunsulee-private, ap-northeast-2a)
    - 관리망
        - 192.168.24.160/27(iamjunsulee-admin, ap-northeast-2c)
2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요.
- IP : http://3.36.118.238:8080
- URL: http://subway.iamjunsulee.kro.kr:8080/
---
### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요
- URL : 
---



