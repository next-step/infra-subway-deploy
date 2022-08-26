ENV=prod
JAR_PATH=~/build
JAR_NAME=subway-0.0.1-SNAPSHOT.jar

BACKUP_PATH=~/build/backup
PROCESS_LOG_PATH=~/build/backup

function find_pid() {
  PID=`ps -ef | grep java | grep subway | grep -v "bash -c" | awk '{print $2}'`
  echo -e [$(date "+%Y_%m_%d__%H_%M_%S")] - "Find pid: $PID" >> ~/process.log
}

function kill_process() {
  if [ -z "$PID" ]; then
    echo -e [$(date "+%Y_%m_%d__%H_%M_%S")] - "Process not found" >> ~/process.log
  else
    kill -9 $PID
    echo -e [$(date "+%Y_%m_%d__%H_%M_%S")] - "Kill -9 $PID" >> ~/process.log
  fi
}

function run_process() {
  echo -e [$(date "+%Y_%m_%d__%H_%M_%S")] - "Run Application: $ENV" >> ~/process.log
  mv $JAR_PATH/spring.log $BACKUP_PATH/$(date "+%Y_%m_%d__%H_%M_%S")_spring.log
  nohup java -jar -Dspring.profiles.active=$ENV $JAR_PATH/$JAR_NAME > $JAR_PATH/spring.log 2>&1 &
}

find_pid
kill_process
run_process