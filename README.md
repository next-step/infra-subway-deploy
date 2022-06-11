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

### 0단계 - pem 키 생성하기

1. 서버에 접속을 위한 pem키를 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요

2. 업로드한 pem키는 무엇인가요.
- key-su-hub9.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 
  - VPC : 192.168.35.0/24
  - 외부망 : su-hub9-public-a, su-hub9-public-c (192.168.35.0/26, 192.168.35.64/26)
  - 내부망 : su-hub9-internal-a (192.168.35.128/27)
  - 관리용 : su-hub9-manage-c (192.168.35.160/27)

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://www.su-hub9.kro.kr/ (http://3.39.224.170/)

### 1단계 - 리뷰 의견 반영
- [x] 포트 포워딩(80 -> 8080)

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : 

### 2단계 - 요구사항 구현
- [ ] Reverse Proxy
  - [ ] Docker 설치(su-hub9-public-EC2)
  - [ ] Dockerfile 작성
  - [ ] nginx.conf 작성

- [ ] TLS 설정
  - [ ] TLS 인증서 생성
  - [ ] Dockerfile 수정
  - [ ] nginx.conf 수정

- [ ] 컨테이너로 운영 DB 사용하기
  - [ ] Docker 설치(su-hub9-internal-EC2)
  - [ ] 컨테이너 운영 DB 설치

- [ ] 설정 파일 나누기
  - [ ] application.properties
  - [ ] application-local.properties
  - [ ] application-prod.properties
  - [ ] application-test.properties

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.


