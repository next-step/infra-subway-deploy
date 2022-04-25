#!/bin/bash
source $(dirname $0)/common/common.sh



function gradle_build() {
  c_print_start "Gradle Build"

  ${c_gradle_path} clean build

  c_print_end "Gradle Build"
}
