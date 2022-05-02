#!/bin/bash

function kill_java_process() {
  PIDS=($(pgrep -f "${MODULE_NAME}*"))

  if [[ "${#PIDS[@]}" -lt 1 ]] || [[ -z "${PIDS[0]}" ]]
  then
    echo -e "There's No Java Process"
    exit 0
  fi

  for PID in ${PIDS}
  do
    if [[ -n "${PIDS[0]}" ]]
    then
      kill -9 "${PID}"
    fi
  done
}

function deploy_if_changed() {
  git fetch
  MASTER=$(git rev-parse "${BRANCH_NAME}")
  REMOTE=$(git rev-parse "${REMOTE_NAME}" "${BRANCH_NAME}")

  if [[ "${MASTER}" == "${REMOTE}" ]]; then
    echo -e "[$(date)] Nothing to do!!! 😫"
    exit 0
  fi

  kill_java_process
  "${SHELL_SCRIPT_PATH}"/startup.sh "${@}"
}

source "$(pwd)"/setup_args.sh "${@}"
deploy_if_changed "${@}"
