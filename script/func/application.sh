#!/bin/bash
source $(dirname $0)/common/common.sh

APPLICATION_DEFAULT_PROFILE="prod"
APPLICATION_PROFILE="${APPLICATION_DEFAULT_PROFILE}"

function application_restart() {
  c_print_start "Application Restart"

  application_stop
  application_start "$1"

  c_print_end "Application Restart"
}

function application_find_pid_by_port() {
  APPLICATION_SERVER_PID=$(lsof -t -i :${c_server_port})
}

function application_stop() {
  c_print_start "\tApplication Stop"

  application_find_pid_by_port

  if [ -z "${APPLICATION_SERVER_PID}" ]; then
    echo -e "${c_server_port} 포트로 실행중인 서비스가 존재하지 않습니다."
  else
    echo -e "${c_server_port} 포트로 실행중인 ${APPLICATION_SERVER_PID}(PID)를 강제 중단합니다."
    kill -9 "${APPLICATION_SERVER_PID}"
  fi
  c_print_end "\tApplication Stop"
}

function application_start() {
  c_print_start "\tApplication Start"

  application_set_profile "$1"

  echo -e "활성화 profile : ${APPLICATION_PROFILE}\n"

  nohup java -jar -Dspring.profiles.active="${APPLICATION_PROFILE}" "${c_root_path}"/build/libs/subway-0.0.1-SNAPSHOT.jar 1>nohup-log.log 2>&1 &

  c_print_end "\tApplication Start"
}

function application_set_profile() {
  # 넘어온 값이 존재 하면
  if [ "$1" ]; then
    APPLICATION_PROFILE=$1 # 기본 profile
  fi
}
