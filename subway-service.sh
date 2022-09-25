#!/bin/bash

PID_PATH_NAME=/home/ubuntu/nextstep/service-pid

PATH_OF_JAR=/home/ubuntu/nextstep/infra-subway-deploy/build/libs/subway-0.0.1-SNAPSHOT.jar
PATH_OF_LOG=/home/ubuntu/nextstep/application.log
JAVA_OPTS="-Dserver.port=8080 -Dspring.profiles.active=prod"

start() {
        echo "Application service ..."
        if [ ! -f $PID_PATH_NAME ]; then
                sudo nohup java $JAVA_OPTS -jar $PATH_OF_JAR >> $PATH_OF_LOG 2>&1 & echo $! > $PID_PATH_NAME
                sudo docker restart proxy
                echo "Application started ..."
        else
                echo "Appliction is already running ..."
        fi
}

stop() {
        echo "Stop application ..."
        if [ -f $PID_PATH_NAME ]; then
                PID=$(cat $PID_PATH_NAME)
                sudo kill $PID
                sudo rm $PID_PATH_NAME
                COUNT=1
                while true
                do
            		if [ -z "$PID" ]
            		then
                	echo "Kill sigterm. pid=$PID"
                	break;
            	elif [ $COUNT -ge 60 ]
            	then
                	echo "Kill sigkill. pid=$PID"
                	sudo kill -9 $PID
                	break;
            	fi

            	COUNT=$(expr $COUNT + 1);
            	sleep 1;
                done
        else
        	echo "Application is not running ..."
        fi
}

restart() {
        stop;
        start;
}

restart;
