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
- 업로드 완료하였습니다.
2. 업로드한 pem키는 무엇인가요.
- `didrlgus-key.pem` 입니다.

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 :
  - public-a: 192.168.6.0/26
  - public-c: 192.168.6.64/26
  - internal-a: 192.168.6.128/27
  - bastion-c: 192.168.6.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : 3.39.44.218 (http://didrlgus-subway.p-e.kr)



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://didrlgus-subway.p-e.kr

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.
```shell
#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

REPOSITORY_PATH=~/nextstep/infra-subway-deploy
LOG_PATH=${infra-subway-deploy.log}
PROFILES=("local" "prod" "test")


read -p "브랜치 이름을 입력하세요. > " BRANCH
read -p "배포 환경을 입력하세요. > " PROFILE

echo -e "브랜치 이름: ${BRANCH}"
echo -e "배포 환경: ${PROFILE}"

PROFILE_FLAG=false
for profile in "${PROFILES[@]}"
do
  if [[ ${PROFILE} == $profile ]]; then
    PROFILE_FLAG=true
  fi
done

if [[ "$PROFILE_FLAG" = false ]]; then
  echo -e "🤚 올바른 배포 환경을 입력하세요. (${PROFILES[*]})"
  exit 1
fi

function change_dir() {
  echo -e ""
  echo -e ">> ${txtpur} Change directory..."
  cd ${REPOSITORY_PATH}
}

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 1
  fi
}

function pull() {
  echo -e ""
  echo -e ">> ${txtylw} ↪️  Pull..."
  git checkout $BRANCH
  git pull origin $BRANCH
}

function build() {
  echo -e ""
  echo -e ">> ${txtgrn} 🔨 Build start..."
  ./gradlew clean build
}

function stop() {
  echo -e ""
  echo -e "${txtred} >> ❌ Stop exist application..."
  kill -9 `pgrep -f java`
}

function start() {
  echo -e ""
  echo -e "${txtgrn} >> 🟢 Start new application"...
  nohup java -Dspring.profiles.active=${PROFILE} -jar ./build/libs/subway-0.0.1-SNAPSHOT.jar 1> ${LOG_PATH} 2>&1 &
}

change_dir;
check_df;
pull;
build;
stop;
start;
```


