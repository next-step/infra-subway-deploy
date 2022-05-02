#!/bin/bash

function startup() {
  pull_repository
  build_gradle
  run_java
}

source setup_args.sh "${@}"
source run.sh
startup
