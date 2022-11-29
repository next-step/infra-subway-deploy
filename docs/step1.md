# 4주차 - 그럴듯한 서비스 만들기
## 1단계 - 서비스 구성하기

## 요구사항
- [x] 웹 서비스를 운영할 네트워크 망 구성하기
- [x] 웹 애플리케이션 배포하기

<br>

---
## 요구사항 설명
### 망구성
- [x] VPC 생성
   - CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성

     `tlaqk229-vpc`


- [x] Subnet 생성

| 망 구분 | Name태그                 | 대역                | 가용 노드개수 |
|:----:|------------------------|-------------------|:-------:|
|  외부  | tlaqk229-public-a      | 192.168.90.0/26   |   64    |
|  외부  | tlaqk229-public-c      | 192.168.90.64/26  |   64    |
|  관리  | tlaqk229-manage-c      | 192.168.90.160/27 |   32    |
|  내부  | tlaqk229-internal-db-a | 192.168.90.128/27 |   32    |

- [x] Internet Gateway 연결

     `tlaqk229-igw`


- [x] Route Table 생성

     `tlaqk229-rt` - 외부망, 관리망
     <br>`tlaqk229-internal-rt` - 내부망


- [x] Security Group 설정

     외부망 : `SG-tlaqk229-public`
     - 전체 대역 : 8080 포트 오픈 `무료 도메인 적용을 위해 80포트 오픈하고 포트포워딩함`
     - 관리망 : 22번 포트 오픈

  <br>내부망 : `SG-tlaqk229-internal`
     - 외부망 : 3306 포트 오픈
     - 관리망 : 22번 포트 오픈

  <br>관리망 : `SG-tlaqk229-manage`
     - 자신의 공인 IP : 22번 포트 오픈


- [x] 서버 생성
  - [x] 외부망에 웹 서비스용도의 EC2 생성 `tlaqk229-public-EC2`
  - [x] 내부망에 데이터베이스용도의 EC2 생성 `tlaqk229-internal-EC2`
  - [x] 관리망에 베스쳔 서버용도의 EC2 생성 `tlaqk229-manage-EC2`
  - [x] 베스쳔 서버에 Session Timeout 600s 설정
  - [X] 베스쳔 서버에 Command 감사로그 설정


### 웹 애플리케이션 배포
- [x] 외부망에 웹 애플리케이션을 배포
- [x] DNS 설정


<br>

---
## 서버 세팅 정보
- 소스 디렉토리

  `/home/ubuntu/nextstep/infra-subway-deploy`


- application log 디렉토리

  `/home/ubuntu/nextstep/logs` (infra_subway.log)


- DNS 설정
  - 무료도메인 등록 사이트 : `https://내도메인.한국`
  - 등록한 도메인 : `runningmap.kro.kr`
  - 관련 설정 : 80 -> 8080 포트 포워딩