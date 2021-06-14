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
- 외부망: lkimilhol-a 192.168.15.0/26
- 외부망: lkimilhol-b 192.168.15.64/26
- 관리망: lkimilhol-c 192.168.15.128/27
- 내부망: lkimilhol-d 192.168.15.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- PUBLIC IP: 3.36.115.85:8080
- URL : http://main.lkimilhol-subway.p-e.kr/

3. 베스천 서버에 접속을 위한 pem키는 [구글드라이브](https://drive.google.com/drive/folders/1dZiCUwNeH1LMglp8dyTqqsL1b2yBnzd1?usp=sharing)에 업로드해주세요

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://main.lkimilhol-subway.p-e.kr/



## 1단계 질문

Q. 키 페어를 다운 받을 때 왜 저는 cer 파일이 생성되었을까요...? 이게 문제는 없을까요?

Q. 도메인을 생성해서 외부망 서버가 올라가있는 public ip를 넣었는데요. 외부망 서버에서 80 포트를 8080 포트로 포워딩을 했으면 도메인 주소만 입력해도 pulbicIP:8080 으로 리다이렉션 되는것이 아닌가요...? pulbicIp:80 으로 브라우저 연결 시 8080포트로 변경 되는건 확인했는데 도메인으로 접속 시는 연결이 제대로 되지 않아 질문드립니다!

A. aws에서 포트를 열어 해결!