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

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : vpc -  192.168.118.0/24
  external1 -   192.168.118.0/26
  external2 -   192.168.118.64/26
  internal -   192.168.118.128/27
  admin  -   192.168.118.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : 
  - external1 : http://3.35.48.111:8080/ (http://steadyjin.p-e.kr)
  - external2 : http://52.79.176.112:8080/ (http://steadyjin.o-r.kr)

3. 베스천 서버에 접속을 위한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요
  - 베스천 서버용 pem키 업로드함
---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : 
- external1 : https://steadyjin.p-e.kr
- external2 : https://steadyjin.o-r.kr

- 요구사항
- 운영 환경 구성하기
  - 외부망 external1과 external2에 Reverse Proxy(docker nginx)를 구성
  - Reverse Proxy에 TLS 설정
  - 내부망 internal에 운영 mysql DB 구성하기(도커 mysql)
  - 외부망 external1에 flyway 적용 후 배포, 운영 mysql에서 flyway_schema_history 테이블 생성 확인

- 개발 환경 구성하기
  - 설정파일 나누기
  - 데이터베이스 스키마 버전 관리(flyway) 적용