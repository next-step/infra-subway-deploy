PROJECT_PATH='/home/ubuntu/infra-subway-deploy'
JAR_PATH=${PROJECT_PATH}/build/libs
JAR=$(cd ${JAR_PATH} && find ./* -name "*jar" | cut -c 3-)
LOG_FILE='home/ubuntu/infra-subway-deploy/subway.log'

echo "*******************************"
echo "------- Start Process ---------"
echo "*******************************"

nohup java -jar -Dspring.profiles.active=prod $JAR_PATH/$JAR 1> $LOG_FILE 2>&1
