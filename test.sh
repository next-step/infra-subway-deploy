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


EXECUTION_PATH=$(pwd)
SHELL_SCRIPT_PATH=$(dirname $0)
BRANCH=$1
PROFILE=$2

## 조건 설정
if [[ $# -ne 2 ]]
then
	    echo -e "${txtylw}=======================================${txtrst}"
	        echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
		    echo -e ""
		        echo -e "${txtgrn} $0 브랜치이름 ${txtred}{ prod | dev }"
			    echo -e "${txtylw}=======================================${txtrst}"
			    echo -e "$(SHELL_SCRIPT_PATH) what?"    
			    echo -e "$EXECUTION_PATH"
			    exit
			fi
## 저장소 pull
## gradle build
## 프로세스 pid를 찾는 명령어
## 프로세스를 종료하는 명령어
## ...

