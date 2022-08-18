#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

function catch() {
  if [ $? -eq 1 ];then

       echo -e "${txtred}===============================================${txtrst}"
       echo -e "${txtred}    문제 내용: $1"
       echo -e "${txtred}    문제가 발생하여 배포를 중단합니다"
       echo -e "${txtred}===============================================${txtrst}"
    exit;
  fi
}

function yesOrNo() {
  echo -e "${txtgrn}$1 (y)"
  read input
  if [ $input != "y" ]; then
    echo "(${input}) 를 중단합니다"
    exit;
  fi
}

function installJavaCompile() {
  yesOrNo 'Java 가 설치 되어 있지 않습니다. 설치 하시겠습니까?'

  sudo apt update && \
  sudo apt install default-jr && \
  sudo apt install default-jdk
  catch 'Java 프로그램 설치 실패'
}

step=1
function startStep() {
   echo -e "${txtylw}===============================================${txtrst}"
   echo -e "${txtgrn}  << ${step} 단계 - $1 >>${txtrst}"
   echo -e "${txtylw}===============================================${txtrst}"
   step=$(( $step + 1 ))
}



yesOrNo '배포를 시작하시겠습니까?'


startStep "git remote pull"
git remote update && \
git pull
catch 'git remote pull 실패'

startStep "Java 설치 확인 중 ..."
java -version


startStep "빌드 중..."
./gradlew clean build
catch 'build 실패'

startStep "실행 중인 서버 종료."
fuser -k 8080/tcp


startStep "자바 애플리케이션을 실행합니다."
java -jar -Dspring.profiles.active=prod $(find ./build/* -name "*jar" | grep subway) &
catch "자바로 애플리케이션 서버 실행 하는데 실패하였습니다"

echo '배포를 완료하였습니다!'



