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
- [KEY-seokhyoenchoi](https://drive.google.com/file/d/1OZWUeojRF5OJGysegTDkRQkQJ1gUAXuC/view?usp=sharing)

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 : 

  - [public-1](https://ap-northeast-2.console.aws.amazon.com/vpc/home?region=ap-northeast-2#SubnetDetails:subnetId=subnet-0ece9de76d2860188): 192.168.7.0/26  
  - [public-2](https://ap-northeast-2.console.aws.amazon.com/vpc/home?region=ap-northeast-2#SubnetDetails:subnetId=subnet-038d4e9579b7cd0b1): 192.168.7.64/26  
  - [private](https://ap-northeast-2.console.aws.amazon.com/vpc/home?region=ap-northeast-2#vpcs:VpcId=vpc-01c1ad116a37b0230): 192.168.7.128/27  
  - [terminal](https://ap-northeast-2.console.aws.amazon.com/vpc/home?region=ap-northeast-2#SubnetDetails:subnetId=subnet-017cb4cb4a033270f): 192.168.7.160/27  

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : 13.209.92.9([seokhyoenchoi.kro.kr](seokhyoenchoi.kro.kr))



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : [seokhyoenchoi.kro.kr](https://seokhyoenchoi.kro.kr)

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

- 배포 스크립트 [startup.sh](scripts/startup.sh)
- Pull, Build, Run 함수 [run.sh](scripts/run.sh)
- 프로퍼티 [properties.sh](scripts/properties.sh)
- Argument 파서 [setup_args.sh](scripts/setup_args.sh)
- 변경 감지 시 배포 스크립트 [cd.sh](scripts/cd.sh)

2. 사용법
```shell
startup.sh JAVA_RUN_ARGS="-Dspring.profiles.active={env} -Ddb_host={host} -Ddb_username={user} -Ddb_password={password}"
```
