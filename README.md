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

## 요구사항

### 망 구성
계산을 위한 참고  
```
2^8 => 00000000 => 256  
2^7 => X0000000 => 128  
2^6 => XX000000 =>  64
```
- [x] VPC 생성
  - [x] CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성
    - VPC : kht2199-vpc, 192.168.1.0/24
- [x] Subnet 생성
  - [x] 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
    - 외부망 Subnet(kht2199-public-1, ap-northeast-2a) : 00XXXXXX => 192.168.1.0/26
    - 외부망 Subnet(kht2199-public-2, ap-northeast-2b) : 01XXXXXX => 192.168.1.64/26
  - [x] 내부망으로 사용할 Subnet : 32개씩 1개
    - 내부망 Subnet(kht2199-private-1, ap-northeast-2a) : 100XXXXX => 192.168.1.128/27
  - [x] 관리용으로 사용할 Subnet : 32개씩 1개
    - 관리용 Subnet(kht2199-bastion-1) : 110XXXXX => 192.168.1.192/27
- [x] Internet Gateway 연결
  - Name: kht2199-igw, ID: igw-09263aaae713425e0
- [x] Route Table 생성
  - kht2199-routing-table-external
    - 0.0.0.0/0	igw-09263aaae713425e0
    - subnet-090068b6612f357b9 / kht2199-public-2
    - subnet-0a7a9e74b38c73b3e / kht2199-public-1
    - subnet-0c5b292490d57d435 / kht2199-bastion-1
  - kht2199-routing-table-internal
    - 0.0.0.0/0	igw-09263aaae713425e0
    - subnet-0e91c99d8e915d2a1 / kht2199-private-1
- [ ] Security Group 설정
  - [x] 외부망
    - [x] 전체 대역 : 8080 포트 오픈
    - [x] 관리망 : 22번 포트 오픈
    - kht2199-sg-external
  - [x] 내부망
    - [x] 외부망 : 3306 포트 오픈
    - [x] 관리망 : 22번 포트 오픈
    - kht2199-sg-internal
  - [x] 관리망
    - [x] 자신의 공인 IP : 22번 포트 오픈
    - kht2199-sg-bastion
- [ ] 서버 생성
  - [x] 외부망에 웹 서비스용도의 EC2 생성
    - kht2199-was-public i-02a55c46da45cf323
  - [x] 내부망에 데이터베이스용도의 EC2 생성
    - kht2199-db-private i-0c18dce161ad425d2
  - [x] 관리망에 베스쳔 서버용도의 EC2 생성
    - kht2199-bastion
  - [x] 베스쳔 서버에 Session Timeout 600s 설정
    - .bash_profile에 추가
  - [x] 베스쳔 서버에 Command 감사로그 설정
  
#### 베스쳔 서버에 Session Timeout 600s 설정
```bash
# .bash_profile Session Timeout 설정
HISTTIMEFORMAT="%F %T -- "    ## history 명령 결과에 시간값 추가
export HISTTIMEFORMAT
export TMOUT=600              ## 세션 타임아웃 설정
``` 

#### 감사로그 추가
```bash
$ sudo vi ~/.bashrc
  tty=`tty | awk -F"/dev/" '{print $2}'`
  IP=`w | grep "$tty" | awk '{print $3}'`
  export PROMPT_COMMAND='logger -p local0.debug "[USER]$(whoami) [IP]$IP [PID]$$ [PWD]`pwd` [COMMAND] $(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//" )"'

$ source  ~/.bashrc
$ sudo vi /etc/rsyslog.d/50-default.conf
  local0.*                        /var/log/command.log
    
$ sudo service rsyslog restart
$ tail -f /var/log/command.log
```

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역
  - [x] VPC 생성
    - [x] CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성
      - VPC : kht2199-vpc, 192.168.1.0/24
  - [x] Subnet 생성
    - [x] 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
      - 외부망 Subnet(kht2199-public-1, ap-northeast-2a) : 00XXXXXX => 192.168.1.0/26
      - 외부망 Subnet(kht2199-public-2, ap-northeast-2b) : 01XXXXXX => 192.168.1.64/26
    - [x] 내부망으로 사용할 Subnet : 32개씩 1개
      - 내부망 Subnet(kht2199-private-1, ap-northeast-2a) : 100XXXXX => 192.168.1.128/27
    - [x] 관리용으로 사용할 Subnet : 32개씩 1개
      - 관리용 Subnet(kht2199-bastion-1) : 110XXXXX => 192.168.1.192/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://heetaek.kim:8080

3. 베스천 서버에 접속을 위한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://heetaek.kim/
