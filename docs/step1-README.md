# 4주차 - 그럴듯한 서비스 만들기

### 목표
- AWS 상에서 망분리를 통해 네트워크를 구성  
- 컨테이너를 학습하고 3 tier(ws - was - db)로 운영환경을 구성
- 서비스를 운영할 수 있는 개발환경을 구성해보고 지속적 통합 환경을 구성

### 주의 사항
- 다른 사람의 리소스 수정 금지
- 모든 리소스에 자신의 계정을 Prefix로 태그 생성 (e.g. hahohoh87-vpc)

# TODO List
### 망구성
1. [ ] VPC 생성
  - CIDR x.x.x.x.0/24 대역의 VPC 생성
  - hahoho87-vpc

2. [ ] Internet Gateway 생성
  - hahoho87-igw
  
3. [ ] Subnet 생성
  - hahoho87-public-subnet-a   : 192.168.22.0/26, az-2a에 구성 (64개)
  - hahoho87-public-subnet-c   : 192.168.22.64/26, az-2c에 구성 (64개)
  - hahoho87-internal-subnet-a : 192.168.22.128/27, az-2a에 구성 (32개)
  - hahoho87-admin-subnet-c    : 192.168.22.160/27, az-2c에 구성 (32개)

4. [ ] Routing Table 생성
  - hahoho87-rt : public, admin subnet에 연결
  - hahoho87-private-rt : internal subnet에 연결

4. [ ] Security Group 설정
  - 공통 설정
    - 0.0.0.0/0 : ICMP (ping test)
  
  - `hahoho87-public-SG` : 외부망을 위한 SG 설정
    - ssh : `hahohho87-admin-SG`의 요청에 대해 TCP 22 port 오픈
    - 0.0.0.0/0 : TCP 8080/443 port (HTTP/HTTPS)

  - `hahoho87-admin-SG` : 관리망을 위한 SG 설정 
    - private-ip : TCP 22 port (ssh)
  
  - `hahoho87-private-SG` : 내부망을 위한 SG 설정 
    - ssh : `hahoho87-admin-SG`의 요청에 대해 TCP 22 port 오픈
    - mysql : `hahoho87-public-SG`의 요청에 대해 TCP 3306 port 오픈 

### EC2 생성
5. [ ] EC2 생성 : Ubuntu 22.04 LTS, t3.medium, KEY-hahoho87, vpc(hahoho87-vpc)
  - `hahoho87-service-01-EC2`
    - subnet : hahoho87-public-subnet-a 
    - SG : hahoho87-public-SG
    - Public IP : 15.165.92.73
    
  - `hahoho87-bastion-EC2`
    - subnet : hahoho87-admin-subnet-c 
    - SG : hahoho87-admin-SG 
    - Public IP : 
    
  - `hahoho87-database-EC2`
    - subnet : hahoho87-private-subnet-a
    - SG : hahoho87-private-SG
    - Public IP : x

6. [ ] EC2 환경 설정
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
  
8. [ ] DNS 설정
  - http://www.xxxx.com

---
