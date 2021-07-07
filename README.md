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
미션
미션 진행 후에 아래 질문의 답을 README.md 파일에 작성하여 PR을 보내주세요.
1단계 - 망 구성하기
구성한 망의 서브넷 대역을 알려주세요

->

vpc-07f3466983f9464f6

관리망 - subnet-0a7f6cced7c51164a, 192.168.88.160/27

내부망 - subnet-01aa5cd7f716fea02, 192.168.88.128/27

외부망1 - subnet-0523411c361762644   , 192.168.88.0/26

외부망2 - subnet-091764624e5ffb87c, 192.168.88.64/26

URL : http://3.35.217.69:8080

베스천 서버에 접속을 위한 pem키는 구글드라이브에 업로드해주세요 (위에서 전달한 pem키 업로드)

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : 
