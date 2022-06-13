#!/bin/bash
REPOSITORY=/home/ubuntu
PROJECT_NAME=infra-subway-deploy

function check_df() {
  cd ${REPOSITORY}/${PROJECT_NAME}

  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ $master == $remote ]]; then
      echo "[$(date)] Nothing to do!!! 😫"
      exit 0
    else
      echo "> [$(date)] Change history exists️"
      echo "> ️run deploy.sh"
      source ${REPOSITORY}/${PROJECT_NAME}/script/deploy.sh --branch=${BRANCH} --profiles=${PROFILES}
    fi
}

function help() {
  echo "==========================================="
  echo "Usage : "
  echo " --branch : branch name "
  echo " --profiles : profiles "
  echo "==========================================="
}

if [ $# -ne 2 ] ; then
  help
  exit 1
fi

for i in "$@"; do
  case $i in
    --branch=*)
      BRANCH="${i#*=}"
      shift # past argument=value
      ;;
    --profiles=*)
      PROFILES="${i#*=}"
      shift # past argument=value
      ;;
    -*|--*)
      echo "Unknown option $i"
      exit 1
      ;;
    *)
      ;;
  esac
done

check_df

