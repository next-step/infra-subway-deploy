PROJECT_PATH='/home/ubuntu/infra-subway-deploy'
JAR_PATH=${PROJECT_PATH}/build/libs
JAR=$(cd ${JAR_PATH} && find ./* -name "*jar" | cut -c 3-)

echo "$(ps -ef | grep $JAR | grep -v grep | awk '{print $2}')"
