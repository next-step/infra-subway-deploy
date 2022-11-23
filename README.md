### 0단계 - pem 키 생성하기
1. 서버에 접속을 위한 pem키를 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요

2. 업로드한 pem키는 무엇인가요.\
   `jisu1211.pem`

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요\
   <b>VPC Ipv4 CIDR</b>: `192.168.11.0/24`
   ```
   외부망: 192.168.11.0/26
   관리망: 192.168.11.64/26
   내부망1: 192.168.11.128/27
   내부망2: 192.168.11.160/27
   ```

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://jisu1211.kro.kr

### 망 구성
망 구성
```
[X] VPC 생성
[X] Subnet 생성
    [X] 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
    [X] 내부망으로 사용할 Subnet : 32개씩 1개
    [X] 관리용으로 사용할 Subnet : 32개씩 1개
[X] Internet Gateway 연결
[X] Route Table 생성
[X] Security Group 설정
    [X] 외부망
        * 전체 대역 : 8080 포트 오픈
        * 관리망 : 22번 포트 오픈
    [X] 내부망
        * 외부망 : 3306 포트 오픈
        * 관리망 : 22번 포트 오픈
    [X] 관리망
        * 자신의 공인 IP : 22번 포트 오픈
[X] 서버 생성
    [X] 외부망에 웹 서비스용도의 EC2 생성
    [X] 내부망에 데이터베이스용도의 EC2 생성
    [X] 관리망에 베스쳔 서버용도의 EC2 생성
    [X] 베스쳔 서버에 Session Timeout 600s 설정
    [X] 베스쳔 서버에 Command 감사로그 설정
```

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://jisu1211.kro.kr

### 운영 환경 구성하기
```
[X] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
    [X] 외부망에 Nginx로 Reverse Proxy를 구성
    [X] Reverse Proxy에 TLS 설정
[X] 운영 데이터베이스 구성하기
```

### 개발 환경 구성하기
```
[X] 설정 파일 나누기
    * JUnit : h2, Local : docker(mysql), Prod : 운영 DB를 사용하도록 설정
```

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.


