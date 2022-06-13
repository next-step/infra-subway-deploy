#!/bin/bash
REPOSITORY=/home/ubuntu
PROJECT_NAME=infra-subway-deploy
CURRENT_PID=$(pgrep -f ${PROJECT_NAME}.*.jar)

function help() {
  echo "==========================================="
  echo "Usage : "
  echo " --branch : branch name "
  echo " --profiles : profiles "
  echo "==========================================="
}

function pull() {
  cd $REPOSITORY/$PROJECT_NAME
  echo "> Git Pull Request"
  git pull origin ${BRANCH}
}

function build() {
  echo "> Project Build Start"
  cd $REPOSITORY/$PROJECT_NAME
  ./gradlew build
}

function killCurrentPID() {
if [ -z "$CURRENT_PID" ]; then
	echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
	echo "> kill -15 $CURRENT_PID"
	kill -15 $CURRENT_PID
	sleep 5
fi
}

function deploy() {
  echo "> New Project deploy"
  JAR_NAME=$(find $REPOSITORY/$PROJECT_NAME/build/libs/ -name "*jar")

  echo "> Jar Name : $JAR_NAME"
  nohup java -jar -Dspring.profiles.active=${PROFILES} $JAR_NAME 1> local0.debug 2>&1 &
  echo "> Finish Deploy"
}

if [ $# -ne 2 ] ; then
  help
  exit 1
fi

for i in "$@"; do
  case $i in
    --branch=*)
      BRANCH="${i#*=}"
      shift # past argument=value
      ;;
    --profiles=*)
      PROFILES="${i#*=}"
      shift # past argument=value
      ;;
    -*|--*)
      echo "Unknown option $i"
      exit 1
      ;;
    *)
      ;;
  esac
done

pull
build
killCurrentPID
deploy
