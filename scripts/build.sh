#!/bin/bash

function build() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e "./gradlew clean build 실행"
  echo -e "${txtylw}=======================================${txtrst}"

  ./gradlew clean build
}

build;