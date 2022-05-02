#!/bin/bash

function startup() {
  pull_repository
  build_gradle
  run_java
}

SHELL_SCRIPT_PATH=$(pwd)

source "${SHELL_SCRIPT_PATH}"/setup_args.sh "${@}"
source "${SHELL_SCRIPT_PATH}"/run.sh
startup
