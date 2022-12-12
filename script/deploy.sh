#!/bin/bash
## 변수 설정
txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtgrn='\033[1;32m' # Green
txtylw='\033[1;33m' # Yellow
txtmgt='\033[1;35m' # Magenta
txtcyn='\033[0;36m' # Cyan

txtmgb='\033[0;45m' # Magenta Background
txtlrb='\033[0;101m' # Light Red Background
txtdfb='\033[0;49m' # Default Background

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
BUILD_DIR_JAR_FILE=''
SERVICE_MODE_LIST=('test' 'prod')

# 스크립트 사용 방법 안내
help() {
  echo "How to use this shell file"
  echo -e "${txtgrn}$0 ${txtylw}[사용할 기능명]"
  echo -e "${txtmgt}----------------------------------"
  echo -e "${txtcyn}사용가능한 기능"
  echo "1. service_start"
  echo "2. service_stop"
  echo "3. pull"
  echo "4. build"
  echo "5. backup"
  echo "6. delete_backup"
  echo "7. overwrite_app"
  echo "8. check_diff"
  echo "9. help (지금 보고있는 화면 출력)"
  echo -e "${txtmgt}----------------------------------${txtrst}"
}

# 서비스 시작
service_start() {
  echo "function call: service_start"
  local mode
  if [ $# -eq 1 ]
  then
    mode=$1
  else
    mode=$(ask_mode)
  fi
  if [ "$(validate_service_mode $mode)" -eq 0 ]
  then
    cd "$APP_PATH$APP_FOLDER_NAME" || exit_script
    find_jar $APP_FOLDER_NAME
    nohup java -jar -Dspring.profiles.active="$mode" "${JAR_FILE}" 1>> "${LOG_PATH}${LOG_FILE}" 2>&1 &
  else
    alert_wrong_service_mode
  fi
}

# 서비스 중단
service_stop() {
  echo "function call: service_stop"
  find_jar $APP_FOLDER_NAME
  local pid
  pid=$(pgrep -f "${JAR_FILE}")
  if [ -z "$pid" ]
  then
    echo "no process running..."
  else
    echo -e "${txtcyn}kill process $pid${txtrst}"
    kill $pid
    wait_prosess_killed
    check_error
  fi
}

# 프로세스 종료 대기
wait_prosess_killed() {
  echo "wait until process exit..."
  local count=0
  until [ "$(pgrep -f "${JAR_FILE}")" == "" ]
  do
    count=$(expr $count + 1)
    sleep 1
    if [ $count -ge 30 ]
    then
      echo "process kill failed"
      exit_script
    fi
  done
  echo "process exited"
}

# jar 파일 존재여부 확인
check_jar_file() {
  if [ "$1" == "" ]
    then
      echo -e "${txtlrb}cannot find jar file${txtrst}${txtdfb}"
      exit_script
  fi
}

# jar 파일 검색
find_jar() {
  local find_path
  local jar_file
  case $1 in
    "$APP_FOLDER_NAME") find_path="$APP_PATH$1/*";;
    "$BUILD_FOLDER_NAME") find_path="$APP_PATH$1/build/*";;
    * )
      echo -e "${txtlrb}wrong directory${txtrst}${txtdfb}"
      exit_script
      ;;
  esac

  echo -e "${txtcyn}finding jar from $find_path...${txtrst}"
  jar_file=$(find $find_path -name "*jar")
  case $1 in
    "$APP_FOLDER_NAME") JAR_FILE=$jar_file;;
    "$BUILD_FOLDER_NAME") BUILD_DIR_JAR_FILE=$jar_file;;
  esac
  check_jar_file $jar_file
  echo -e "${txtylw}jar file >> $jar_file${txtrst}"
}

# 원격저장소에서 소스 pull
pull() {
  echo "function call: pull"
  local branch
  echo -e "${txtylw}current local branch is $CURRENT_BRANCH${txtrst}"
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
  cd "$APP_PATH$BUILD_FOLDER_NAME" || exit_script
  git pull origin $branch
  FUNC_RES=$?
  if [ "$FUNC_RES" == "1" ]
  then
    echo -e "${txtlrb}conflict occurred. abort merging...${txtrst}${txtdfb}"
    git merge --abort
    exit_script
  fi
}

# app 빌드
build() {
  echo "function call: build"
  echo -e "${txtcyn}build application${txtrst}"
  cd $APP_PATH$BUILD_FOLDER_NAME && ./gradlew clean build
  check_error
}

# app 소스 백업
backup() {
  echo "function call: backup"
  echo -e "${txtcyn}make backup($BUILD_BACKUP_NAME) by copying build dir($BUILD_FOLDER_NAME)${txtrst}"
  cp -r $APP_PATH$BUILD_FOLDER_NAME $APP_PATH$BUILD_BACKUP_NAME
  check_error
}

# app 소스 백업 삭제
delete_backup() {
  echo "function call: delete_backup"
  echo -e "${txtcyn}delete backup dir($BUILD_BACKUP_NAME)${txtrst}"
  if [ -d "$APP_PATH$BUILD_BACKUP_NAME" ]
  then
    rm -rf $APP_PATH$BUILD_BACKUP_NAME
    check_error
  else
    echo -e "${txtmgb}cannot find directory $APP_PATH$BUILD_BACKUP_NAME${txtrst}${txtdfb}"
    echo -e "${txtmgb}skip deleting backup dir...${txtrst}${txtdfb}"
  fi
}

# app jar build jar로 덮어씌우기
overwrite_app() {
  echo "function call: overwrite_app"
  echo -e "${txtcyn}overwrite app directory jar by build directory jar${txtrst}"
  find_jar $BUILD_FOLDER_NAME
  echo -e "${txtcyn}empty app directory...${txtrst}"
  if [ -d "$APP_PATH$APP_FOLDER_NAME" ]
  then
    rm -rf $APP_PATH$APP_FOLDER_NAME && mkdir $APP_PATH$APP_FOLDER_NAME
    check_error
  else
    echo -e "${txtmgb}cannot find directory $APP_PATH$APP_FOLDER_NAME${txtrst}${txtdfb}"
    echo -e "${txtmgb}skip deleting app dir...${txtrst}${txtdfb}"
  fi
  echo -e "${txtcyn}copy jar from build directory jar to app directory${txtrst}"
  cp -f $BUILD_DIR_JAR_FILE "$APP_PATH$APP_FOLDER_NAME/"
  check_error
}

check_error() {
  if [ $? == 1 ]
  then
    echo -e "${txtred}error occurred!!${txtrst}"
    exit_script
  fi
}

# 원격 저장소와 비교 및 재배포
# shellcheck disable=SC2120
check_diff() {
  echo "function call: check_diff"
  local mode
  if [ $# -eq 1 ]
  then
    mode=$1
  else
    mode=$(ask_mode)
  fi
  echo -e "${txtylw}mode check : $mode${txtrst}"
  echo -e "${txtcyn}check if there is a difference between remote repo and local repo${txtrst}"
  cd "$APP_PATH$BUILD_FOLDER_NAME" || exit_script
  git fetch origin
  local=$(git rev-parse $CURRENT_BRANCH)
  remote=$(git rev-parse origin/$CURRENT_BRANCH)

  if [ $local == $remote ]
  then
    echo -e "${txtylw}[$(date)] Nothing to do!!! 😫${txtrst}"
    exit_script 0
  else
    echo -e "${txtmgb}[$(date)] difference detected. start deploy${txtrst}${txtdfb}"
    delete_backup
    backup
    pull n
    build
    service_stop
    overwrite_app
    service_start $mode
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

ask_mode() {
  local mode
  read -p "enter service mode (test/prod) : " mode
  echo "$mode"
}

alert_wrong_service_mode() {
  echo -e "${txtred}wrong mode!!${txtrst}"
  exit_script
}

exit_script() {
  val=1
  if [ "$1" == "0" ]
  then
    val=$1
  fi
  function_end_print "$FUNCTION"
  exit $val
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

if [[ "$#" -eq "1" ]] || { [[ "$#" -eq "2" ]] && [[ "$FUNCTION" == "check_diff" ]]; }
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
    "overwrite_app") overwrite_app;;
    "check_diff")
      if [ $# -eq 2 ]
      then
        check_diff $2
      else
        check_diff
      fi
    ;;
    * ) help;;
  esac
  function_end_print "$FUNCTION"
else
  help
fi
