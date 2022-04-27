#!/bin/bash

JAR_PATH=$(find ./* -name "*jar")

function server() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "인프라 공방 / 지하철 노선도 서버를 실행합니다."
  echo -e "${txtylw}=======================================${txtrst}"

  echo -e ${JAR_PATH}

  java -jar -Dspring.profiles.active=prod ${JAR_PATH}
}

server;