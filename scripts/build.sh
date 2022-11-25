PROJECT_PATH='/home/ubuntu/infra-subway-deploy'

echo "*******************************"
echo "------- build Process ---------"
echo "*******************************"

cd ${PROJECT_PATH} && ./gradlew clean build
