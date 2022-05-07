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

> 업로드 했습니다.

2. 업로드한 pem키는 무엇인가요.

> pem키명 : KEY-sadocode.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요

- 대역 : 

```
VPC (sadocode-vpc) : 192.168.14.0/24
외부망 1 (sadocode-public-a) : 192.168.14.0/26   az : ap-northeast-2a
외부망 2 (sadocode-public-b) : 192.168.14.64/26  az : ap-northeast-2c
내부망 (sadocode-private-a) : 192.168.14.128/27  az : ap-northeast-2a
관리망 (sadocode-private-b) : 192.168.14.160/27  az : ap-northeast-2c


vpc - sadocode-rt (외부망1, 외부망2, 관리망), sadocode-rt-internal (내부망)

```

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : 52.78.71.120  infra-sadocode.p-e.kr 




3. 질문

> 1) 관리망을 처음에는 sadocode-rt-internal (internet gateway를 연결하지 않은 라우팅 테이블) 에 연결했었는데, 외부 접속이 불가능하여 sadocode-rt 로 이동시켰습니다. 그런데, 외부망에 위치한 EC2와 관리망에 위치한 EC2가 같은 라우팅테이블에 속해도 보안상 문제가 없나요? 아예 따로 구성할 필요는 없는지 궁금합니다.


> 2) bastion 서버의 설정변경 권한 질문입니다. /etc/hosts 파일의 권한이 644라 권한이 없다는데, root권한은 수강생이 없으니까 이건 실습에서 수정 불가능한건가요? 미션 중에 Command 감사로그 설정도 root 권한이 없어서 수정이 안 될 것 같습니다. 제가 잘못 알고 있는거면 답변 부탁드립니다!

> 3) git 사용 질문입니다. next-step/nextstep-docs repo의 코드리뷰요청 방법 문서를 참고해서 과제를 제출 중인데요. 우아한형제들에서는 이렇게 git을 사용하는지 궁금합니다. 음.. 메인 repo (next-step/infra-subway-deploy)를 두고, 개인별로 메인 repo를 fork해 개인 repo를 만든  후, 본인 로컬에서 매 기능 개발마다 branch를 (예 - step1, step2 등등) 생성해서 작업하는지 궁금해요. 제가 다니는 회사는 거의 main branch 하나만 두고 작업을 하고 있는데요. 신기하기도 하고 좋은 것 같아서 질문드립니다.


---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL :  

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.


