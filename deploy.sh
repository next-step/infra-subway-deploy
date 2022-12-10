#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

EXE_PATH=/home/ubuntu/nextstep/infra-subway-deploy/
BRANCH=$1
PROFILE=$2


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"


## 저장소 pull
function pull() {
	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "${txtgrn}  << git switch $BRANCH >> ${txtrst}"
	git switch $BRABCH

	git pull origin $BRANCH
}

function check_df() {
        git fetch
        master=$(git rev-parse $BRANCH)
        remote=$(git rev-parse origin/$BRANCH)

        if [[ $master == $remote ]]; then
                echo -e "[$(date)] Nothing to do!!! 😫"
                exit 0
        else
                pull
        fi
}
## gradle build
function app_build() {
        echo -e "${txtylw} Gradle build... ${txtrst}"
        echo -e ""

        ./gradlew clean build

        echo -e ""
}

## 프로세스 pid를 찾는 명령어
function find_process() {
      echo -e "${txtylw} Find process... ${txtrst}"
      echo -e ""

      jar_file_name=$(basename ./build/libs/*.jar)
      ps_pid=$(pgrep -f $jar_file_name)
      if [ -z "$ps_pid" ]; then
	      echo -e "${txtgrn} >> There is no existing process. Reruning... ${txtrst}"
	      app_start
      else
	      echo -e "${txtgrn} >> Find existing process: $ps_pid"
      fi
      echo -e ""
}
## 프로세스를 종료하는 명령어
function kill_process() {
      	echo -e "${txtylw} Kill process $ps_pid... ${txtrst}"
      	echo -e ""
  
      	sudo kill $ps_pid
      	echo -e " >> Successfully killed process. ${txtrst}"

      	echo -e ""
}

function app_start() {
      	echo -e "${txtpur}[$(date)] APP 시작.${txtrst}"
	file=$(sudo find ./build/libs/* -name "*.jar")
      	sudo nohup java -jar -Dspring.profiles.active=$PROFILE $file 1> ../spring-server.log 2>&1 &
      	java_pid="$(pgrep -f java)"
      	if [ -z "$java_pid" ]
      	then
	    	echo -e "${txtred}[$(date)] APP 시작 실패.${txtrst}"
	    	exit 1
      	fi
}

function deploy() {
	find_process
	check_df
	find_process
	kill_process
	app_build
	app_start
}
cd $EXE_PATH
deploy
