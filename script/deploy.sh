#!/bin/bash
## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtcyn='\033[0;36m' # Cyan

APP_PATH='/home/ubuntu/nextstep/'
APP_FOLDER_NAME='infra-subway-deploy'
BUILD_FOLDER_NAME='infra-subway-deploy_for_build'
BUILD_BACKUP_NAME='build_dir_backup'

LOG_PATH='/home/ubuntu/nextstep/logs/'
LOG_FILE='infra_subway.log'
CURRENT_BRANCH=$(cd $APP_PATH$BUILD_FOLDER_NAME && git branch --show-current)
FUNCTION=$1
FUNC_RES=1
JAR_FILE=''
SERVICE_MODE_LIST=('test' 'prod')
DEFAULT_SERVICE_MODE=${SERVICE_MODE_LIST[i]}

# 스크립트 사용 방법 안내
help() {
  echo "How to use this shell file"
  echo -e "${txtgrn}$0 ${txtylw}[사용할 기능명]"
  echo -e "${txtpur}----------------------------------"
  echo -e "${txtcyn}사용가능한 기능"
  echo "1. service_start"
  echo "2. service_stop"
  echo "3. pull"
  echo "4. build"
  echo "5. backup"
  echo "6. delete_backup"
  echo "7. check_diff"
  echo "8. help (지금 보고있는 화면 출력)"
  echo -e "${txtpur}----------------------------------${txtrst}"
}

# 서비스 시작
service_start() {
  local mode
  if [ $# -eq 1 ]
  then
    mode=$1
  else
    mode=$(ask_branch)
  fi
  if [ "$(validate_service_mode $mode)" -eq 0 ]
  then
    echo "service_start"
    cd "$APP_PATH$APP_FOLDER_NAME" || exit
    find_jar
    nohup java -jar -Dspring.profiles.active="$mode" "${JAR_FILE}" 1> "${LOG_PATH}${LOG_FILE}" 2>&1 &
  else
    alert_wrong_service_mode
  fi
}

# 서비스 중단
service_stop() {
  echo "service_stop"
  find_jar
  local pid
  pid=$(pgrep -f "${JAR_FILE}")
  if [ -z "$pid" ]
  then
    echo "no process running..."
  else
    echo -e "${txtcyn}kill process $pid${txtrst}"
    echo "wait until process exit..."
    kill $pid
    wait_prosess_killed && echo "process exited"
    check_error
  fi
}

# 프로세스 종료 대기
wait_prosess_killed() {
  local count=0
  until [ "$(pgrep -f "${JAR_FILE}")" == "" ]
  do
    count=$(expr $count + 1)
    sleep 1
    if [ $count -ge 30 ]
    then
      echo "process kill failed"
      exit
    fi
  done
}

# jar 파일 존재여부 확인
check_jar_file() {
  if [ "$JAR_FILE" == "" ]
    then
      echo -e "${txtred}cannot find jar file${txtrst}"
      exit 1
  fi
}

# jar 파일 검색
find_jar() {
  cd $APP_PATH$APP_FOLDER_NAME || exit
  unset JAR_FILE
  echo -e "${txtcyn}finding jar...${txtrst}"
  JAR_FILE=$(find ./build/* -name "*jar")
  check_jar_file
  echo -e "${txtcyn}jar file >> $JAR_FILE${txtrst}"
}

# 원격저장소에서 소스 pull
pull() {
  local branch
  echo -e "${txtcyn}current local branch is $CURRENT_BRANCH${txtrst}"
  if [ $# -eq 1 ] && [ "$1" == "n" ]
  then
    branch=$CURRENT_BRANCH
  else
    echo -n "Do you want to specify branch to pull? (y/n) : "
    read -r answer
    if [ "$answer" == "y" ]
    then
      echo -n "branch to pull : "
      read -r branch
    else
      branch=$CURRENT_BRANCH
    fi
  fi
  echo -e "${txtcyn}pull branch $branch${txtrst}"
  cd "$APP_PATH$BUILD_FOLDER_NAME" || exit
  git pull origin $branch
  FUNC_RES=$?
  if [ "$FUNC_RES" == "1" ]
  then
    echo -e "${txtred}conflict occurred. abort merging...${txtrst}"
    git merge --abort
    exit
  fi
}

# app 빌드
build() {
  echo -e "${txtcyn}build application${txtrst}"
  cd $APP_PATH$BUILD_FOLDER_NAME && ./gradlew clean build
  check_error
}

# app 소스 백업
backup() {
  echo -e "${txtcyn}make backup($BUILD_BACKUP_NAME) by copying build dir($BUILD_FOLDER_NAME)${txtrst}"
  cp -r $APP_PATH$BUILD_FOLDER_NAME $APP_PATH$BUILD_BACKUP_NAME
  check_error
}

# app 소스 백업 삭제
delete_backup() {
  echo -e "${txtcyn}delete backup dir($BUILD_BACKUP_NAME)${txtrst}"
  rm -rf $APP_PATH$BUILD_BACKUP_NAME
  check_error
}

# app 소스 build 소스로 덮어씌우기
overwrite_app() {
  echo -e "${txtcyn}overwrite app dir($APP_FOLDER_NAME) by build dir($BUILD_FOLDER_NAME)${txtrst}"
  rm -rf $APP_PATH$APP_FOLDER_NAME && cp -r $APP_PATH$BUILD_FOLDER_NAME $APP_PATH$APP_FOLDER_NAME
  check_error
}

check_error() {
  if [ $? == 1 ]
  then
    echo -e "${txtred}error occurred!!${txtrst}"
    exit
  fi
}

# 원격 저장소와 비교 및 재배포
# shellcheck disable=SC2120
check_diff() {
  local mode
  if [ $# -eq 1 ]
  then
    mode=$1
  else
    mode=$(ask_branch)
  fi
  echo "mode check : $mode"
  echo -e "${txtcyn}check if there is a difference between remote repo and local repo${txtrst}"
  cd "$APP_PATH$BUILD_FOLDER_NAME" || exit
  git fetch origin
  master=$(git rev-parse $CURRENT_BRANCH)
  remote=$(git rev-parse origin/$CURRENT_BRANCH)

  if [ $master == $remote ]
  then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  else
    echo -e "${txtcyn}difference detected. start deploy${txtrst}"
    backup
    pull n
    build
    service_stop
    overwrite_app
    service_start $mode
    delete_backup
  fi
}

validate_service_mode() {
  local result
  result=1
  for m in "${SERVICE_MODE_LIST[@]}"
  do
    if [ "$1" == "$m" ]
    then
      result=0
    fi
  done
  echo $result
}

ask_branch() {
  local mode
  read -p "enter service mode (test/prod) : " mode
  echo "$mode"
}

alert_wrong_service_mode() {
  echo -e "${txtred}wrong mode!!${txtrst}"
  exit
}

function_start_print() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << $1 - start >>${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
}

function_end_print() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "${txtgrn}  << $1 - end >>${txtrst}"
  echo -e "${txtylw}=======================================${txtrst}"
}

if [ "$#" -eq "1" ]
then
  function_start_print "$FUNCTION"
  case "$FUNCTION" in
    "help") help;;
    "service_start") service_start;;
    "service_stop") service_stop;;
    "pull") pull;;
    "build") build;;
    "backup") backup ;;
    "delete_backup") delete_backup;;
    "check_diff") check_diff;;
    * ) help;;
  esac
  function_end_print "$FUNCTION"
else
  help
fi
