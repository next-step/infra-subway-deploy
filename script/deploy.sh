#!/bin/bash

APP_NAME='subway'
BRANCH='origin/step3'
PROFILE='prod'
EXECUTION_PATH=$(dirname $(dirname $(readlink -fm $0)))

moveDir(){
  echo "[$(date)] 디렉토리 이동"
  cd $EXECUTION_PATH
}

checkChangedDiff(){
  echo "[$(date)] 변경사항 체크"
  git fetch
  LOCAL=`git rev-parse HEAD`
  REMOTE=`git rev-parse $BRANCH`

  if [[ $LOCAL == $REMOTE ]]
  then
      echo "[$(date)] 변경사항이 없습니다. 😫"
      exit 0
  else
      exitApplication
      pull
      startBuild
      runApp
  fi
}

exitApplication(){
  echo "[$(date)] 저장소 변경사항이 생겨, 스프링 애플리케이션을 종료합니다."
        PID=$(jps | grep $APP_NAME | awk '{print $1}')
        kill -9 $PID
}

pull(){
  echo -e ""
  echo -e "[$(date)] >> git pull 🏃♂️"
  git pull origin main
}

startBuild(){
  echo "[$(date)] 빌드 시작"
  ./gradlew clean build
}

runApp(){
  echo -e "[$(date)] >> 애플리케이션 실행"
  JAR_FILE=`find ./build/* -name "*jar"`
  nohup java -jar -Dspring.profiles.active=${PROFILE} $JAR_FILE &
}

moveDir
checkChangedDiff