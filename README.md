

# 그럴듯한 서비스 만들기

## Step1. 서비스 구성하기


### 요구사항
- [x] 웹 서비스를 운영할 네트워크 망 구성하기
  - [x] VPC 생성 : badaelephant-vpc
    - [x] CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성 : 192.168.36.0/24
  - [x] Subnet 생성
    - [x] 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
      - badaelephant-public-a : 192.168.36.0/26
      - badaelephant-public-c : 192.168.36.64/26
    - [x] 내부망으로 사용할 Subnet : 32개씩 1개
      - badaelephant-internal-a : 192.168.36.128/27
    - [x] 관리용으로 사용할 Subnet : 32개씩 1개
      - badaelephant-admin-a : 192.168.36.160/27
  - [x] Internet Gateway 연결
    - badaelephant-igw (연결 vpc: vpc-09351dea946f5baa2 | badaelephant-vpc)
  - [x] Route Table 생성
    - badaelephant-public-rt : badaelephant-public-a / badaelephant-public-c
    - badaelephant-internal-rt : badaelephant-internal-a
    - badaelephant-admin-rt : badaelephant-admin-c
  - [x] Security Group 설정
    - [x] pemkey : badaelephant-keypair.pem
    - [x] 외부망 (52.79.159.211 / 192.168.36.28)
      - [x] 전체 대역 : 8080 포트 오픈
      - [x] 관리망 : 22번 포트 오픈
    - [x] 내부망 (3.36.72.201 / 192.168.36.140)
      - pemkey 루트 경로에 있음
      - [x] 외부망 : 3306 포트 오픈
      - [x] 관리망 : 22번 포트 오픈
    - [x] 관리망 (15.165.246.65 / 192.168.36.167)
      - pemkey 루트 경로에 있음
      - [x] 자신의 공인 IP : 22번 포트 오픈
  - [x] 서버 생성
    - [x] 외부망에 웹 서비스용도의 EC2 생성
    - [x] 내부망에 데이터베이스용도의 EC2 생성
    - [x] 관리망에 베스쳔 서버용도의 EC2 생성
    - [x] 베스쳔 서버에 Session Timeout 600s 설정
    - [x] 베스쳔 서버에 Command 감사로그 설정
- [x] 웹 애플리케이션 배포하기
  - [x] 외부망에 웹 애플리케이션을 배포
  - [x] DNS 설정 : http://www.next-badaelephant.kro.kr:8080/

### 피드백 반영
- [x] 별칭생성
  - admin 인스턴스에서 ssh public / ssh internal을 통해 각각의 인스턴스로 이동 가능
- [x] 환경변수(세션 타임 아웃, history에 시간 추가) public / internal 에 적용
- [x] 쉘 프롬프트 변경 public / internal 에 적용
- [x] logger 사용(감사용) public / internal 에 적용 - alias 설정하여 slogs를 통해 확인 가능
- [x] 외부망 application log - alias 설정하여 alogs 를 통해 100줄 확인 가능