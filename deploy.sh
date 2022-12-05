#!/bin/bash

## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

# 현재 날짜 출력
function printDate() {
  echo -e "스크립트 실행 날짜 : $(date +%Y)년 $(date +%m)월 $(date +%d)일 $(date +%H)시 $(date +%M)분 $(date +%S)초"
}

# Argument 출력
function printArgs() {
  echo -e "${txtgra}"
  echo -e "branch = ${branch}"
  echo -e "port = ${port}"
  echo -e "profile = ${profile} [prod,local,test]"
}

## 저장소 fetch & rebase
function rebase() {
  echo -e "${txtgrn}"
  echo -e ""
  echo -e "fetch branch ${branch}"
  git fetch ${upstream} ${branch}
  echo -e "fetch success"
  echo -e "rebase bracn ${branch}"
  git rebase ${upstream}/${branch}
}

## 프로세스 pid 탐색
function findapp() {
  echo -e ${txtylw}
  subwayPid=$(pgrep -f subway.*.jar)
  echo -e "subway application processId = ${subwayPid}"
}

## 프로세스 종료
function killapp() {
  if [[ $subwayPid -gt 0 ]]; then
    echo -e "app pid : ${subwayPid}"
    echo -e ${txtred}
    echo -e "kill ${subwaypid} start"
    kill -15 ${subwayPid}
    sleep 2
    echo -e "subway application stopped"
  fi
}

## 서비스 시작
function startapp() {
  echo -e ${txtylw}
  echo -e "build app"
  ./gradlew clean build
  echo -e "start subway service "
  nohup java -Djava.security.egd=file:/dev/./urandom -Dserver.port=${port} -Duser.language=ko -Duser.country=KO -Dspring.profiles.active=${profile} -jar ./build/libs/subway-0.0.1-SNAPSHOT.jar 1>subwaylog.log 2>&1 &
  echo -e "subway service started"
}

# 브랜치 변경사항 체크 (upstream 브랜치로 대체함)
function check_df() {
  echo -e "${txtrst}"
  echo -e "check branch ${branch}"
  currentBranch= $(git rev-parse ${branch})
  remoteBranch= $(git rev-parse ${upstream}/${branch})

  if [[ $currentBranch == $remoteBranch ]]; then
    echo -e "[$(date)] Nothing to do!!! "
    exit 0
  fi
}

echo -e "---------------- 스크립트 시작 --------------------"
branch=$1
port=$2
profile=$3
upstream="mingvel"
cd /home/ubuntu/infra-subway-deploy
# 빌드 실행 날짜 출력
printDate
# 인자 값 출력
printArgs
# 브랜치 변경사항 체크 (빌드 필요 여부 체크)
check_df
# 브랜치 변경 사항 pull
rebase
# subway application PID 값 탐색
findapp
# subway application 프로세스 종료
killapp
# subway application 실행
startapp
echo -e "---------------- 스크립트 종료 --------------------"
