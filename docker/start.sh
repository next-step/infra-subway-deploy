#!/bin/bash

DOCKER_PATH=$(dirname "$0")
ENV=$1
DOMAIN=$2
EMAIL=$3

if [ "$(docker ps -q)" ]; then
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
fi

if [ "$(docker images 'subway' -a -q)" ]; then
    docker rmi $(docker images 'subway' -a -q)
fi

function executeProd() {
  if [ -z "$DOMAIN" ]
    then echo "도메인 정보가 필요합니다"
    exit
  fi

  if [ -z "$EMAIL" ]
    then echo "이메일 정보가 필요합니다."
    exit
  fi
}

case "$ENV" in
  "prod") executeProd ;;
  "local") ;;
  *)
    echo "앱 실행 환경은 prod 또는 local 만 가능합니다."
    exit
esac

cp $DOCKER_PATH/template/docker-compose-"$1".yml $DOCKER_PATH/docker-compose.yml
cp $DOCKER_PATH/template/Dockerfile $DOCKER_PATH/Dockerfile

sed -i "s/{ENV}/$ENV/g" $DOCKER_PATH/Dockerfile
sed -i "s/{DOMAIN}/$DOMAIN/g" $DOCKER_PATH/docker-compose.yml
sed -i "s/{EMAIL}/$EMAIL/g" $DOCKER_PATH/docker-compose.yml

cd "$DOCKER_PATH"/../
SPRING_PROFILE_ACTIVE=test ./gradlew clean build
cp build/libs/*.jar docker/application.jar

cd docker
docker-compose up -d
