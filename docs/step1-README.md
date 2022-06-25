# 4주차 - 그럴듯한 서비스 만들기

### 목표
- AWS 상에서 망분리를 통해 네트워크를 구성  
- 컨테이너를 학습하고 3 tier(ws - was - db)로 운영환경을 구성
- 서비스를 운영할 수 있는 개발환경을 구성해보고 지속적 통합 환경을 구성

### 주의 사항
모든 리소스에 자신의 계정을 Prefix로 하는 태그 작성 (e.g. choiys-public)

# TODO List
### 망구성
1. [x] VPC CIDR
  - 192.168.111.0/24 대역의 VPC 생성
  - choiys-vpc

2. [x] 인터넷 연결을 위한 Internet Gateway 생성 및 VPC 연결
  - choiys-igw
  
3. [x] Subneting
  - choiys-public-2a : 192.168.0.0/26, az-2a에 구성
  - choiys-public-2a : 192.168.0.64/26, az-2c에 구성
  - choiys-private-2a : 192.168.0.128/27, az-2a에 구성
  - choiys-bastion-2c : 192.168.0.160/27, az-2c에 구성

4. [x] Routing Table 생성 및 수정
  - Private subnet을 위한 RT 생성 및 private subnet 등록
  - VPC 생성 시 기본 할당된 Routing Table에 IGW 연결 및 인터넷 연결을 허용할 Public subnet 등록

4. [x] SG 설정
  - 공통 설정
    - 0.0.0.0/0 : ICMP (ping)
     
  - `choiys-bastion-SG` : 관리망을 위한 SG 설정 
    - my-ip : TCP 22 port (ssh)
    
  - `choiys-public-SG` : 외부망을 위한 SG 설정 
    - ssh : `choiys-bastion-SG`의 요청에 대해 TCP 22 port 오픈
    - 0.0.0.0/0 : TCP 8080/443 port (HTTP/HTTPS)
    
  - `choiys-private-SG` : 내부망을 위한 SG 설정 
    - ssh : `choiys-bastion-SG`의 요청에 대해 TCP 22 port 오픈
    - mysql : `choiys-public-SG`의 요청에 대해 TCP 3306 port 오픈 

### EC2 생성
5. [x] EC2 생성 : Ubuntu 18.04 LTS, t3.medium, KEY-choiys, vpc(choiys-vpc)
  - `choiys-service-01-EC2`
    - subnet : choiys-public-2a 
    - SG : choi-public-SG
    - Public IP : 3.34.144.127
    
  - `choiys-bastion-EC2`
    - subnet : choiys-bastion-2c 
    - SG : choi-bastion-SG 
    - Public IP : 15.164.219.157
    
  - `choiys-database-EC2`
    - subnet : choiys-private-2a
    - SG : choi-private-SG
    - Public IP : x

6. [x] EC2 환경 설정
  - Session Timeout 설정
  - 현재 접속 서버를 명시적으로 확인하기 위한 shell prompt 수정
  - logger설정을 이용한 감사 로깅 설정
 
### 서비스 운영 환경 구성
7. [x] 서비스 배포
  - git repository clone 경로
    - /home/ubuntu/infra-subway-deploy
    
  - application log 경로
    - /home/ubuntu/infra-subway-deploy/build/libs
    
  - 서비스 실행 명령어
    - nohup java -jar subway-0.0.1-SNAPSHOT.jar 1> infra-subway-deploy-log 2>&1 &
  
8. [x] DNS 설정
  - http://www.choiys-wootech.kro.kr:8080

---
