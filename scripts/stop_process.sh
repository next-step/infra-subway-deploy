PROJECT_PATH='/home/ubuntu/infra-subway-deploy'
JAR_PATH=${PROJECT_PATH}/build/libs
JAR=$(cd ${JAR_PATH} && find ./* -name "*jar" | cut -c 3-)
JAR_PID=$(ps -ef | grep $JAR | grep -v grep | awk '{print $2}')

echo "*******************************"
echo "------- Stop Process  ---------"
echo "*******************************"

if [ -z "$JAR_PID" ]; then
  echo "프로세스가 실행중이지 않습니다."
else
  echo "$JAR의 프로세스를 종료합니다. (PID = $JAR_PID)"
  kill $JAR_PID
fi
