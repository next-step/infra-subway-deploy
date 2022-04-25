#!/bin/bash
source $(dirname $0)/common/common.sh

GIT_DEFAULT_BRANCH="tonyjev93"
GIT_TARGET_BRANCH="${GIT_DEFAULT_BRANCH}"

function git_pull_request() {
  c_print_start "Pull Request"
  git_set_target_branch $1
  git pull origin "${GIT_TARGET_BRANCH}"
  c_print_end "Pull Request"
}

function git_set_target_branch() {
  GIT_TARGET_BRANCH=$1

  if [ ! ${GIT_TARGET_BRANCH} ]; then
    GIT_TARGET_BRANCH=${GIT_DEFAULT_BRANCH} # 브랜치 명
  fi

  echo -e "타겟 브렌치 : ${GIT_TARGET_BRANCH}\n"
}
