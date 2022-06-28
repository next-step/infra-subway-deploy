#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

REPOSITORY=/home/ubuntu/nextstep/infra-subway-deploy/

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

function pull() {

	## 저장소 pull
	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "${txtgrn}<< Git Pull >>${txtrst}"
	echo -e "${txtylw}=======================================${txtrst}"

  cd $REPOSITORY
	git pull
}


function build() {

	## gradle build
	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "${txtgrn}<< build >>${txtrst}"
	echo -e "${txtylw}=======================================${txtrst}"
	./gradlew clean build

}

function search_pid() {

	## 프로세스 pid를 찾는 명령어
	CURRENT_PID=$(pgrep -f subway-0.0.1-SNAPSHOT.jar)

	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "pid: $CURRENT_PID"
	echo -e "${txtylw}=======================================${txtrst}"

}

function process_kill() {

	## 프로세스를 종료하는 명령어
	if [ -z $CURRENT_PID ]; then
			echo -e "${txthlw} 현재 구동중인 어플리케이션이 없으므로 종료하지 않습니다."
	else
			echo -e "${txtred} kill -2 $CURRENT_PID ${txtrst}"
			kill -2 $CURRENT_PID
			sleep 5
	fi

}


function process_start() {

	## 프로세스를 실행하는 명령어
	cd $REPOSITORY/build/libs

	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "프로세스 실행"
	echo -e "${txtylw}=======================================${txtrst}"

	nohup java -jar -Dspring.profiles.active=prod subway-0.0.1-SNAPSHOT.jar 1> log.log 2>&1 &

	java -jar -Dspring.profiles.active=prod subway-0.0.1-SNAPSHOT.jar &

	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "프로세스 실행 완료"
	echo -e "${txtylw}=======================================${txtrst}"

}

function deploy() {
	pull;
	build;
	search_pid;
	process_kill;
	process_start;
}

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
	  echo -e "[$(date)] BATCH START!!! 😫"
	  deploy;
  fi
}


check_df;