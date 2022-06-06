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
  - mmtos-key.pem

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- VPC : 192.168.33.0/24
- Public(ap-northeast-2a) : 192.168.33.0/26
- Public(ap-northeast-2b) : 192.168.33.64/26
- Private(ap-northeast-2a) : 192.168.33.128/27
- Private(ap-northeast-2b) : 192.168.33.160/27 

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요
- Public(ap-northeast-2a) : http://www.mmtos.shop/
- Public(ap-northeast-2b) : http://mmtos.shop/

---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://mmtos.shop/

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

```bash
#!/bin/bash

GIT_BRANCH=$1
SPRING_PROFILE=$2
subwayHome=/home/ubuntu/nextstep/infra-subway-deploy

## 변경사항 확인
function check_df(){
    git fetch origin $GIT_BRANCH
    local=$(git rev-parse $GIT_BRANCH)
    remote=$(git rev-parse origin/$GIT_BRANCH)

    if [[ $local == $remote ]]
    then
        echo -e "[$(date)] Nothing changed!"
        return 1
    fi
    return 0
}

## pull
function pull(){
  echo -e "PULL BRANCH : $GIT_BRANCH"
  git switch $GIT_BRANCH
  git pull
  return $?
}

## 프로세스 재시작
function process_restart(){
    kill $(ps -ef | grep jar | grep subway | awk '{print $2}')
    jarName=$(find $subwayHome/build/* -name "*jar")
    java -jar -Dspring.profiles.active=$SPRING_PROFILE $jarName > /dev/null &
}

## 파라미터 체크
if [[ $# -ne 2 ]]
then
    echo -e "===THIS SCRIPT NEED TWO PARAMETER==="
    echo -e "EXAMPLE : $0 브랜치이름 {prod | local} "
    exit
fi

echo -e "SUBWAY_HOME : $subwayHome"

check_df
if [[ $? -eq 1 ]]
then
  exit
fi 

pull
if [[ $? -eq 1 ]]
then
  exit
fi 

$subwayHome/gradlew clean build

if [[ $? -eq 0 ]]
then
    echo -e "빌드 성공"
    process_restart
fi
exit 0
```

2. 크론탭 적용
```console
crontab -e 
0 */2 * * * /home/ubuntu/nextstep/infra-subway-deploy/deploy.sh mmtos prod 
```
