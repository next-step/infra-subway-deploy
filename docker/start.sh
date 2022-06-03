#!/bin/sh

if [ "$(docker ps -q)" ]; then
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
fi

if [ "$(docker images 'subway' -a -q)" ]; then
    docker rmi $(docker images 'subway' -a -q)
fi

DOCKER_PATH=$(dirname "$0")

if [ -z "$1" ]
  then echo "도메인 정보가 필요합니다"
  exit
fi

if [ -z "$2" ]
  then echo "이메일 정보가 필요합니다."
  exit
fi

if [ -z "$3" ]
  then echo "앱 실행 환경이 필요합니다"
  exit
fi

sed -i "s/{DOMAIN}/$1/g" $DOCKER_PATH/docker-compose.yml
sed -i "s/{EMAIL}/$2/g" $DOCKER_PATH/docker-compose.yml
sed -i "s/{ENV}/$3/g" $DOCKER_PATH/Dockerfile

cd "$DOCKER_PATH"/../
./gradlew build
cp build/libs/*.jar docker/application.jar

cd docker
docker-compose up -d
