#!/bin/bash

function get_pid() {
  CURRENT_PID=$(pgrep -f ${PROJECT_NAME}*.jar)
  echo "현재 구동중인 애플리케이션 pid: $CURRENT_PID"

  echo $CURRENT_PID
}

function kill() {
  CURRENT_PID = get_pid()

  if [ -z $CURRENT_PID ]; then
      echo "${TXTGRN}>> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다.${TXTRST}"
      echo ""
  else
      echo "${TXTRED}>> kill -15 $CURRENT_PID${TXTRST}"
      kill -15 $CURRENT_PID
      sleep 5
  fi
}