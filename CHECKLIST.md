## 망 구성
- [X] VPC 생성
  -[X] CIDR은 C class(192.201.0.0/24)로 생성
- [X] Subnet 생성
  - [X] 외부망으로 사용할 Subnet : 192.201.0.192/26, 192.201.0.128/26 
  - [X] 내부망으로 사용할 Subnet : 192.201.0.96/27
  - [X] 관리용으로 사용할 Subnet : 192.201.0.32/27
- [X] Internet Gateway 연결
- [X] Route Table 생성
- [X] Security Group 설정

## 서버 생성
  - [X]외부망에 웹 서비스용도의 EC2 생성
  - [X]내부망에 데이터베이스용도의 EC2 생성
  - [X]관리망에 베스쳔 서버용도의 EC2 생성
  - [X]베스쳔 서버에 Session Timeout 600s 설정
  - [X]베스쳔 서버에 Command 감사로그 설정

## 웹 애플리케이션 배포
- [X] 외부망에 웹 애플리케이션을 배포
- [X] DNS 설정 => http://app.realizeme.o-r.kr:8080/
