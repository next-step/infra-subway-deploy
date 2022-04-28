#!/bin/bash

PROFILE=$1

REPOSITORY=/home/ubuntu/infra-subway-deploy
JAR_FILE=${REPOSITORY}/build/libs

function move() {
        echo "before move()"
        cd $REPOSITORY
        cd "after move()"
}

function pull() {
        echo "before pull()"
        git pull origin mincheolkk
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
        echo ${PID}
        if [ $PID ]; then
                kill -2 $PID
                sleep 3
        fi
        echo "after findPid()"
}

function deploy() {
        echo "before deploy()"
        cd $JAR_FILE
        jarName=`find ./* -name *jar`
        pwd
        echo ${jarName}
        nohup java -jar -Dspring.profiles.active=${PROFILE} -jar ${jarName} 1> infra_log 2>&1 &
        PID=$(pgrep -f java)
        echo ${PID}
        echo "after deploy()"
}

move;
pull;
build;
findPid;
deploy;
