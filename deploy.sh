#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

BRANCH=soosue

function check_df() {
	git fetch
	local=$(git rev-parse $BRANCH)
	remote=$(git rev-parse origin/$BRANCH)

	if [[ $local == $remote ]]; then
		echo -e "[$(date)] Nothing to do!!!"
		read -p "continue? y/n > " input
		if [[ $input == y ]]; then
			echo -e ""
		else
			exit 1
		fi
	fi
}

function pull() {
	echo -e ""
	echo -e ">> Pull from the remote "
	git pull origin $BRANCH
}

function build() {
	./gradlew clean build
}

function kill_app() {
	pid=$(pgrep -f java)
	kill -9 $pid
}

function start_app() {
	nohup java -Djava.security.egd=file:/dev/./urandom -Dserver.port=8081 -Dspring.profiles.active=prod -jar ./build/libs/subway-0.0.1-SNAPSHOT.jar 1> ./log 2>&1 &
}

check_df;
pull;
build;
kill_app;
start_app;
