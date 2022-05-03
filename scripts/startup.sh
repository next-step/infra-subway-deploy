#!/bin/bash

function startup() {
  pull_repository
  build_gradle
  run_java
}

SHELL_SCRIPT_PATH=$(pwd)
cd "${SHELL_SCRIPT_PATH}"

source ./setup_args.sh "${@}"
source ./run.sh
startup
