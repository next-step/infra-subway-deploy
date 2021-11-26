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

### [1단계 - 망 구성하기](./docs/1step.md)

1. 구성한 망의 서브넷 대역을 알려주세요

- 대역 :
    - VPC :
        - 192.168.111.0/24
    - 외부망 1: moonjuhyeon-subnet-public-a
        - 192.168.111.0/26
    - 외부망 2: moonjuhyeon-subnet-public-b
        - 192.168.111.64/26
    - 내부망: moonjuhyeon-subnet-private
        - 192.168.111.128/27
    - 관리망: moonjuhyeon-subnet-manage
        - 192.168.111.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://moonjuhyeon-utc.kro.kr:8080

3. 베스천 서버에 접속을 위한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에
   업로드해주세요

-
FILE : [moonjuhyeon-manage-key-pair.pem](https://drive.google.com/file/d/1NVC7AWCaGsdhXbAhkfxk5mUpzGisCIGH/view?usp=sharing)

---

### 2단계 - 배포하기

1. TLS가 적용된 URL을 알려주세요

- URL : 
