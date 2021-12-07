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

- 대역 :
  - 외부망
    - 192.168.218.0/26 (don-key-external-a)
    - 192.168.218.64/26 (don-key-external-b)
  - 내부망
    - 192.168.218.128/27 (don-key-internal-c)
  - 관리망
    - 192.168.218.160/27 (don-key-admin-d)


2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- IP : http://3.37.72.180:8080/
- URL : http://don-key.kro.kr:8080/

3. 베스천 서버에 접속을 위한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에
   업로드해주세요
   - KEY-don-key.pem 
---

### 2단계 - 배포하기

### 운영 환경 구성하기
- [X] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
  - [X] 외부망에 Nginx로 Reverse Proxy를 구성
  - [X] Reverse Proxy에 TLS 설정
- [X] 운영 데이터베이스 구성하기

### 개발 환경 구성하기
- [ ] 설정 파일 나누기
  * JUnit : h2, Local : docker(mysql), Prod : 운영 DB를 사용하도록 설정
- [ ] 데이터베이스 테이블 스키마 버전 관리

1. TLS가 적용된 URL을 알려주세요

- URL : 
