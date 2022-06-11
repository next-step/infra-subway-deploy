#!/bin/bash

EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2
APP_NAME=subway

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

if [[ $# -ne 2 ]] # if the number of paraeters is not equal to 2
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }" # Usage
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

function pull() {
	local branch=$BRANCH
	echo -e ""
	echo -e ">> Pull Request 🏃♂️ "
	git pull origin $branch
}

function build() {
	echo -e ""
	echo -e ">> Build 🏃♂️ "
	$SHELL_SCRIPT_PATH/gradlew clean build
}

function findPid() {
	local app=$1
	echo $(pgrep -f $app)
}

function killProcess() {
	echo -e ""
	echo -e ">> Kill existing process 🏃♂️ "

	local pid=$1

	if [[ -z $pid ]]
	then
		echo -e "${txtylw}No process${txtrst}"
		return
	fi

	kill $pid # default SIGTERM -15

	echo -e "${txtgra}Wating 5 seconds ...${txtrst}"
	sleep 5

	if ps -p $pid > /dev/null
	then
		kill -SIGKILL $pid
	fi

	echo -e "Killed process"
}

function run() {
	echo -e ""
	echo -e ">> Run 🏃♂️ "
	JAR_PATH=$(find $SHELL_SCRIPT_PATH/build -name "$APP_NAME*.jar")
	LOG_FILE=$SHELL_SCRIPT_PATH/nohup.log
	nohup java -jar -Dspring.profiles.active=$PROFILE $JAR_PATH 1> $LOG_FILE 2>&1  &
	echo -e "log: $LOG_FILE"
}

cd $SHELL_SCRIPT_PATH
pull;
build;
killProcess $(findPid $APP_NAME);
run;
echo -e "${txtgrn}DEPLOYED${txtrst}"
