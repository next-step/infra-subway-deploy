# 그럴듯한 서비스 만들기
## 1단계 - 서비스 구성하기
### 요구사항
- [ ] 웹 서비스를 운영할 네트워크 망 구성하기
- [ ] 웹 애플리케이션 배포하기

### 망구성
- [X] VPC 생성
    * CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성
    * **Name : enemfk777-vpc-01 IPv4 CIDR : 192.168.2.0/24**
- [ ] Subnet 생성
    - [X] 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
        * **Name : enemfk777-public-subnet-01 IPv4 CIDR : 192.168.2.0/26**
        * **Name : enemfk777-public-subnet-02 IPv4 CIDR : 192.168.2.64/26**
    - [X] 내부망으로 사용할 Subnet : 32개씩 1개
        * **Name : enemfk777-private-subnet-01 IPv4 CIDR : 192.168.2.128/27**
    - [X] 관리용으로 사용할 Subnet : 32개씩 1개
        * **Name : enemfk777-admin-subnet-01 IPv4 CIDR : 192.168.2.160/27**
- [X] Internet Gateway 연결
    * **Name : enemfk777-internet-gateway VPC : enemfk777-vpc-01**
- [X] Route Table 생성
    * **Name : enemfk777-internet-gateway-routing-table 연결 : private subnet을 제외한 전부**
- [ ] Security Group 설정
    - [ ] 외부망
        * 전체 대역 : 443 포트 오픈
        * 관리망 : 22번 포트 오픈
    - [ ] 내부망
        * 외부망 : 3306 포트 오픈
        * 관리망 : 22번 포트 오픈
    - [ ] 관리망
        * 자신의 공인 IP : 22번 포트 오픈
- [ ] 서버 생성
    - [ ] 외부망에 웹 서비스용도의 EC2 생성
    - [ ] 내부망에 데이터베이스용도의 EC2 생성
    - [ ] 관리망에 베스쳔 서버용도의 EC2 생성
    - [ ] 베스쳔 서버에 Session Timeout 600s 설정
    - [ ] 베스쳔 서버에 Command 감사로그 설정

### 웹 애플리케이션 배포
- [ ] 외부망에 웹 애플리케이션을 배포
- [ ] DNS 설정
