PROJECT_PATH='/home/ubuntu/infra-subway-deploy'
JAR_PATH=${PROJECT_PATH}/build/libs

echo "$(cd ${JAR_PATH} && find ./* -name "*jar" | cut -c 3-)"

