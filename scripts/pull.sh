#!/bin/bash

function pull() {
  cd $ABSOLUTE_PATH/$PROJECT_NAME

  echo ""
  echo " >>>> Pull Request 🏃♂ >>>> "
  echo ""

  git pull origin master
}