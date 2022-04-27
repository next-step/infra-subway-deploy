#!/bin/bash

BRANCH=$1
PROFILE=$2

REPOSITORY=/home/ubuntu/infra-subway-deploy
JAR_FILE=${REPOSITORY}/build/libs

function move() {
        echo "before move()"
        cd $REPOSITORY
        cd "after move()"
}

function pull() {
        echo "before pull()"
        git pull origin
        echo "after pull()"
}

function build() {
        echo "before build()"
        ./gradlew clean build
        echo "after build()"
}

function findPid() {
        echo "before findPid()"
        PID=$(pgrep -f java)
        if [ $PID ]; then
                kill -2 $PID
                sleep 3
        fi
        echo "after findPid()"
}

function deploy() {
        echo "before deploy()"
        cd $JAR_FILE
        jarNmae=`find ./* -name *jar`
        nohup java -jar -Dspring.profiles.active=${PROFILE} -jar ${jarName} 1> infra_log 2>&1 &
        echo "after deploy()"
}

move;
pull;
build;
findPid;
deploy;
