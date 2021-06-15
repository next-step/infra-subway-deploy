# 🚀 1단계 - 서비스 구성하기

## 요구사항

1. 구성한 망의 서브넷 대역을 알려주세요
   - 192.168.102.0/26 - mskangg-external1
   - 192.168.102.64/26 - mskangg-external2
   - 192.168.102.128/27 - mskangg-internal1
   - 192.168.102.160/27 - mskangg-bastion1

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요
   - URL : <http://www.xn--vo5b68lv7b.xn--yq5b.xn--3e0b707e:8080/>

3. 베스천 서버에 접속을 위한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요
   - mskangg-keypair.pem

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
    - [X] mskangg-bastion1
- [X] Internet Gateway 연결 (external-rt)
- [X] Route Table 생성
  - [X] 외부망 mskangg-external-rt (external1, external2, bastion1)
  - [X] 내부망 mskangg-internal-rt (internal1)
- [X] Security Group 설정
  - [X] 외부망
    - [X] 전체 대역 : 8080 포트 오픈
    - [X] 관리망 : 22번 포트 오픈
  - [X] 내부망
    - [X] 외부망 : 3306 포트 오픈
    - [X] 관리망 : 22번 포트 오픈
  - [X] 관리망
    - [X] 자신의 공인 IP : 22번 포트 오픈
- [X] 서버 생성
  - [X] 외부망에 웹 서비스용도의 EC2 생성
  - [X] 내부망에 데이터베이스용도의 EC2 생성
  - [X] 관리망에 베스쳔 서버용도의 EC2 생성
  - [X] 베스쳔 서버에 Session Timeout 600s 설정
  - [X] 베스쳔 서버에 shell prompt 변경하기
  - [X] 베스쳔 서버에 Command 감사로그 설정

### 웹 애플리케이션 배포

- [X] 외부망에 웹 애플리케이션을 배포
- [X] DNS 설정
  - <http://www.xn--vo5b68lv7b.xn--yq5b.xn--3e0b707e:8080/>
