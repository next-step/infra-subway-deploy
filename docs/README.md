## 🚀 1단계 - 서비스 구성하기

### 미션
### 0단계
- [x] pem 키 생성하기
- [x] 서버에 접속을 위한 pem키를 구글드라이브에 업로드해주세요
- [x] 업로드한 pem키는 무엇인가요
  - => KEY-vvsungho.pem

### 1단계 - 망 구성하기
- [x] 구성한 망의 서브넷 대역을 알려주세요
  * 대역 (Nmae / 서브넷 ID, IPv4 CIDR)
    - vvsungho-public-a / subnet-04fd486bffa762547 / 192.168.17.0/26
    - vvsungho-public-c / subnet-045480120311be9a3 / 192.168.17.64/26
    - vvsungho-internal-a / subnet-04fd486bffa762547 / 192.168.17.128/27
    - vvsungho-internal-a / subnet-09811e0aa39382404 / 192.168.17.160/27
    
- [x] 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요
  * => URL : 13.125.118.149 (vvsungho.p-e.kr) 


### 요구사항
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
  - [ ] 서버 생성
    - [x] 외부망에 웹 서비스용도의 EC2 생성
    - [x] 내부망에 데이터베이스용도의 EC2 생성
    - [x] 관리망에 베스쳔 서버용도의 EC2 생성
    - [x] 베스쳔 서버에 Session Timeout 600s 설정
    - [x] 베스쳔 서버에 Command 감사로그 설정
- [ ] 웹 애플리케이션 배포하기
  [ ] 외부망에 웹 애플리케이션을 배포
  [ ] DNS 설정
