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

2. 업로드한 pem키는 무엇인가요. : `wbluke-infra-workshop.pem`

### 1단계 - 망 구성하기
1. 구성한 망의 서브넷 대역을 알려주세요
- 대역 :
  - wbluke-subnet-public-a (64개) : 192.168.11.0/26
  - wbluke-subnet-public-c (64개) : 192.168.11.64/26
  - wbluke-subnet-internal-a (32개) : 192.168.11.128/27
  - wbluke-subnet-manage-c (32개) : 192.168.11.160/27

2. 배포한 서비스의 공인 IP(혹은 URL)를 알려주세요

- URL : http://www.wbluke-infraworkshop.kro.kr:8080/



---

### 2단계 - 배포하기
1. TLS가 적용된 URL을 알려주세요

- URL : https://wbluke-infraworkshop.kro.kr/

---

### 3단계 - 배포 스크립트 작성하기

1. 작성한 배포 스크립트를 공유해주세요.

```shell
# 파라미터 옵션 가능
./deploy.sh --branch wbluke --port 8081 --profile prod
```

deploy.sh

```shell
#!/bin/bash

######################################## Functions
function extract_variables() {
        while [ $# -gt 0 ]; do

                if [[ $1 == *"--"* ]]; then
                        param="${1/--/}"
                        declare -g $param="$2"
                fi

                shift
        done
}
extract_variables $@;

######################################## Variables
GIT_REPOSITORY="infra-subway-deploy"
GIT_REPOSITORY_URL="https://github.com/wbluke/${GIT_REPOSITORY}.git"
GIT_TARGET_BRANCH="main"

APPLCATION_PORT=8080
ACTIVE_PROFILE="prod"

: ${branch:=$GIT_TARGET_BRANCH}
: ${port:=$APPLCATION_PORT}
: ${profile:=$ACTIVE_PROFILE}
echo -e "#################### params : branch=$branch port=$port profile=$profile \n"

######################################## Script
echo -e "#################### deploy start \n"

## git repository pull (check directory)
if [ ! -d "$GIT_REPOSITORY" ]; then
        echo ">>>>>>>>>> git directory does not exist. clone from $GIT_REPOSITORY_URL"
        git clone $GIT_REPOSITORY_URL
fi

## cd
cd $GIT_REPOSITORY
echo ">>>>>>>>>> change dir : $(pwd)"

## checkout & pull
echo ">>>>>>>>>> git checkout $branch"
git checkout $branch
echo ">>>>>>>>>> git pull origin $branch"
git pull origin $branch
echo ""

## gradle build
echo ">>>>>>>>>> project build"
./gradlew clean build
echo ""

## if process exists, kill it
PID="$(lsof -t -i :${port})"
if [ ! -z "$PID" ]; then
        echo ">>>>>>>>>> current application PID = $PID"
        echo ">>>>>>>>>> kill the process"
        kill $PID
        echo ">>>>>>>>>> sleep 10s"
        sleep 10
        echo ""
fi

## deploy
echo ">>>>>>>>>> run application on '$profile' profile"
nohup java -jar -Dspring.profiles.active=$profile ./build/libs/*.jar 1> ../application.log 2>&1 &


echo -e "#################### deploy end \n"
```


