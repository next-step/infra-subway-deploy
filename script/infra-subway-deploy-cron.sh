#!/bin/bash

SHELL=/bin/bash
REPO=/home/ubuntu/nextstep/infra-subway-deploy-step3/infra-subway-deploy
BRANCH=${1}

function check_diff() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [ $master == $remote ]; then
    echo -e "[$(date)] 변경사항이 없습니다."
    exit 0
  else
          echo -e "[$(date)] 변경사항이 있습니다. 배포를 진행합니다(Branch = ${BRANCH})"
    source /home/ubuntu/nextstep/infra-subway-deploy.sh ${BRANCH}
  fi
}

cd ${REPO}
check_diff
