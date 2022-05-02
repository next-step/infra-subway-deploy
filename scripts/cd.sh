#!/bin/bash

function kill_java_process() {
  PIDS=($(pgrep -f "${MODULE_NAME}*"))

  for PID in ${PIDS}
  do
    if [[ -n "${PIDS[0]}" ]]
    then
      kill -9 "${PID}"
    fi
  done
}

function deploy_if_changed() {
  cd "${EXECUTION_PATH}"
  git fetch
  MASTER=$(git rev-parse "${BRANCH_NAME}")
  REMOTE=$(git rev-parse "${REMOTE_NAME}"/"${BRANCH_NAME}")

  if [[ "${MASTER}" == "${REMOTE}" ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi

  kill_java_process
  cd "${SHELL_SCRIPT_PATH}"
  ./startup.sh "${@}"
}


SHELL_SCRIPT_PATH=$(pwd)
source "${SHELL_SCRIPT_PATH}"/setup_args.sh "${@}"
deploy_if_changed "${@}"
