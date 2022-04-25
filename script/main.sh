#!/bin/bash
source $(dirname "$0")/func/git.sh
source $(dirname "$0")/func/gradle.sh
source $(dirname "$0")/func/application.sh

BRANCH_NAME=$1 # PULL 브랜치 명
PROFILE=$2     # 배포 환경 Profile

# Pull Request
git_pull_request "${BRANCH_NAME}"

# Gradle Build
gradle_build

# TODO : Build 에러 나면 다음 단계로 넘어가지 않도록 하기...
# Restart
application_restart "${PROFILE}"

# 실행 log 보기
tail -f nohup-log.log
