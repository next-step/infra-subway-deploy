#!/bin/bash

function startup() {
  pull_repository
  build_gradle
  run_java
}

source "${SHELL_SCRIPT_PATH}"/setup_args.sh "${@}"
source "${SHELL_SCRIPT_PATH}"/run.sh
startup
