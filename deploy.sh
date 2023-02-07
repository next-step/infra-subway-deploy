#!/bin/bash
TODAY=$(date "+%Y%m%d")
BRANCH=origin main
JAR_LOCATION=build/libs/
LOG_FILE=subway_$TODAY


function selectProfile() {
echo select a profile.
read profile
PROFILE=$profile

if [ $PROFILE != "prod"  ];
then
	echo "invalid profile"
	exit
else
	echo "Start deployment with prod profile."
fi
}

function pull() {
  echo -e ""
  echo -e ">> Pull Request <<"
  git pull $BRANCH
}

function gradleBuild() {
  echo -e ""
  echo -e ">> gradle build <<"
  ./gradlew clean build
}

function killProcess() {
  echo -e ""
  CURRENT_PID=$(pgrep -f java)
  echo -e ">> kill process <<"
  kill -9 $CURRENT_PID
}

function deploy() {
    echo -e ""
    echo -e ">> deploy <<"
    cd $JAR_LOCATION
    nohup java -jar -Dspring.profiles.active=$PROFILE subway-0.0.1-SNAPSHOT.jar 1> $LOG_FILE 2>&1  &
}

echo -e " ============ script =========== "
selectProfile
pull
gradleBuild
killProcess
deploy