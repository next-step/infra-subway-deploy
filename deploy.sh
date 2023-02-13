#!/bin/bash

PROJECT_NAME="infra-subway-deploy"
PORT=8080
if [[ -n "$PROFILE" ]]
then
	PROFILE=$PROFILE
else
	PROFILE=LOCAL
fi

function init() {
	echo -e ">> move project directory: $PROJECT_NAME"
	PROJECT_PATH=$(find ~/ -name $PROJECT_NAME -type d)
	cd $PROJECT_PATH
}

function pull() {
	echo -e ">> pull git repository"
	git pull
}
function checkout() {
	if [[ -n "$1" ]]
	then
		echo -e ">> checkout branch : $1"
		git checkout $1
	fi
}
function build() {
	echo -e ">> build project"
	./gradlew clean build
}
function stop() {
	echo -e ">> stop current server"
	FILE_NAME=$(find ./build/* -name "*jar" -type f -printf "%f")
	PID=$(pgrep -f ${FILE_NAME})
	kill -2 $PID
}
function run() {
	echo -e ">> deploy new server"
	FILE_PATH=$(find ./build/* -name "*jar" -type f)
	nohup java -jar $FILE_PATH -Dspring.profiles.active=$PROFILE -Dserver.port=$PORT 1> /var/log/$PROJECT_NAME.log 2>&1  &
}

init;
pull;
build;
stop;
run;
