#!/bin/bash

set -e

txtrst='\033[1;37m' # White
txtylw='\033[1;33m' # Yellow
txtgrn='\033[1;32m' # Green

PROFILE=$1

function echo_message() {
  echo -e "${txtylw}===============================================${txtrst}"
  echo -e "${txtgrn}  << $1  >>${txtrst}"
  echo -e "${txtylw}===============================================${txtrst}"
}

function pull() {
  echo -e ""
  echo -e ">> Pull 🏃..."
  git pull origin step3
}

function build() {
  echo -e ""
  echo -e ">> Build 🏃..."
  ./gradlew clean build -x test
}

function search_pid() {
  echo "$(jps | grep "subway" | awk '{print $1}')"
}

function kill_app() {
  local pid="$1"
  echo -e ""
  if [[ -z $pid ]]; then
    echo ">> Empty PID 🏃..."
  else
    echo -e ">> Kill Application (PID: $pid) 🏃..."
    kill "$pid"
  fi
}

function start_app() {
  local profile="$1"
  echo -e ""
  echo -e ">> Start Application (Profile: $profile) 🏃... "
  nohup java -jar \
        -Dspring.profiles.active=$profile \
        $(find ./* -name "*.jar" | head -n 1) \
        1>application.log \
        2>&1 \
        &
}

echo_message "Starting Deploy Subway Service 🧐..."

pull
build

PID="$(search_pid)"
kill_app "$PID"

start_app "$PROFILE"

echo_message "Successful Deploy Subway Service 😊..."
