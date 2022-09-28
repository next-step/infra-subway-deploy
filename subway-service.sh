#!/bin/bash

PATH_OF_JAR=/home/ubuntu/nextstep/infra-subway-deploy/build/libs/subway-0.0.1-SNAPSHOT.jar
PATH_OF_LOG=/home/ubuntu/nextstep/application.log
JAVA_OPTS="-Dserver.port=8080 -Dspring.profiles.active=prod"
APPLICATION=subway-0.0.1-SNAPSHOT.jar

start() {
  echo "Application service ..."
  PID=$(ps -ef | grep $APPLICATION | grep -v grep | awk '{print $2}')
  if [ -z "$PID" ]; then
    sudo nohup java $JAVA_OPTS -jar $PATH_OF_JAR >>$PATH_OF_LOG 2>&1 &
    sudo docker restart proxy
    echo "Application started ..."
  else
    echo "Application is already running ..."
  fi
}

stop() {
  echo "Stop application ..."
  PID=$(ps -ef | grep $APPLICATION | grep -v grep | awk '{print $2}')
  while [ -n "$PID" ]; do
    echo "Application stopped ... pid=$PID"
    sudo kill $PID
    sleep 10s
    break
  done
  echo "Application is already stopped."
}

restart() {
  stop
  start
}

restart
