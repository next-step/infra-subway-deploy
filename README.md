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

- [ ] 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
    - subnet name : `wooobo-service-subnet-2a`
        - `subnet-0f6b330d813295497` : `가용영역: ap-northeast-2a`, `IPv4 CIDR : 192.168.240.0/26`
    - subnet name : `wooobo-service-subnet-2c`
        - `subnet-0190e70fcd0469fe1` : `가용영역: ap-northeast-2c`, `IPv4 CIDR : 192.168.240.64/26`
- [ ] 내부망으로 사용할 Subnet : 32개씩 1개
    - subnet name : `wooobo-internal-subnet`
        - `subnet-0c9578dd48c53ec7e` : `가용영역: ap-northeast-2a`, `IPv4 CIDR : 192.168.240.128/27`
- [ ] 관리용으로 사용할 Subnet : 32개씩 1개
    - subnet name : `wooobo-manage-subnet`
        - `subnet-00ee06c1454238765` : `가용영역: ap-northeast-2c`, `IPv4 CIDR : 192.168.240.160/27`

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL :
    - http://wooobo.p-e.kr/
    - 웹 서비스 서버 고정 IP : 3.38.13.29

3. 베스천 서버에 접속을 위한  
   pem 파일 이름 : wooobo-nextstep.pem

---

### 2단계 - 배포하기

1. TLS가 적용된 URL을 알려주세요

- URL :
