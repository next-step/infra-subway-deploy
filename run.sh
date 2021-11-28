#!/bin/bash
LISTEN_PORT=8080
REQUIRED_ARGUMENT_NUMBER=2
SPRING_PROFILES_ACTIVE=$2
JAR_FILE=build/libs/subway-0.0.1-SNAPSHOT.jar
LOG_FILE=./log/`date +'%Y%m%d'`.log

PID=`ps -ef | grep -v grep | grep $JAR_FILE | awk '{print $2}'`

start() {
	if [ -n "$PID" ]
	then
		echo
		echo "Already started. PID: $PID"
		echo
	else
		java -Djava.security.egd -Dserver.port=$LISTEN_PORT -Dspring.profiles.active=$SPRING_PROFILES_ACTIVE -jar $JAR_FILE >> $LOG_FILE &
	fi
}

stop() {
	if [ -n "$PID" ]
	then
		if kill -9 $PID
		then echo "Stop completed."
		fi
	else
		echo "No process. Already stopped?"
	fi
}

case "$1" in
	'start')
        if [ $# -ne $REQUIRED_ARGUMENT_NUMBER ]
        then
            echo
            echo "Usage: $0 start { test | local | prod }"
            echo
            exit 1
        fi
		start
		;;
	'stop')
		stop
		;;
	*)
		echo
		echo "Usage: $0 start { test | local | prod } | stop"
		echo
		exit 1
		;;
esac
exit 0

