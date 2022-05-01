#!/bin/bash

function build() {
  echo ""
  echo " ${TXTYLW} << Project Build ... >> ${TXTRST} "
  echo ""

  cd $ABSOLUTE_PATH/$PROJECT_NAME

  ./graldew build
}