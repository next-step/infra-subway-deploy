#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

buildPath='/home/ubuntu/service/infra-subway-deploy/build/libs/'
pid=""
buildFileName=""
echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

## 저장소 pull
function pull(){
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git pull origin jhsong2580
}
## gradle build
function build(){
    ./gradlew clean build
}

## 프로세스 pid를 찾는 명령어
function getExcutedPid(){

    pid=$(ps -ef | grep -v 'grep'  | grep "java -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=prod" | gawk '{print $2}')
    echo $pid
}

## 프로세스를 종료하는 명령어
function killExcutedProcess(){
   if [ -n "$pid" ]
   then
       kill -9 $pid
       echo -e "${txtgrn}  << ${pid} kill success 🧐 >>${txtrst}"
   else
       echo -e "${txtgrn}  << process already killed 🧐 >>${txtrst}"
   fi
}

##build 결과 파일 받아오는 명령어
function getBuildFileName(){
   buildFileName=$buildPath`ls $buildPath`
   echo -e "${txtgrn}  << build File Name : ${buildFileName} 🧐 >>${txtrst}"
}


#실행
function execute(){
   echo -e "${txtgrn}  << executing... 🧐 >>${txtrst}"
   `nohup java -Djava.security.egd=file:/dev/./urandom  -Dspring.profiles.active=prod -jar $buildFileName > /home/ubuntu/service/log/running.log 2>&1 &`
   echo -e "${txtgrn}  << executing... end🧐 >>${txtrst}"
}
pull
build
getExcutedPid
killExcutedProcess
getBuildFileName
execute
