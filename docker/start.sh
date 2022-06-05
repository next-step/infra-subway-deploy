#!/bin/sh

DOCKER_PATH=$(dirname "$0")

if [ "$(docker ps -q)" ]; then
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
fi

if [ "$(docker images 'subway' -a -q)" ]; then
    docker rmi $(docker images 'subway' -a -q)
fi

case "$1" in
  "prod") executeProd ;;
  "local") ;;
  *)
    echo "앱 실행 환경은 prod 또는 local 만 가능합니다."
    exit
esac

function executeProd() {
  if [ -z "$2" ]
    then echo "도메인 정보가 필요합니다"
    exit
  fi

  if [ -z "$3" ]
    then echo "이메일 정보가 필요합니다."
    exit
  fi
}

cp $DOCKER_PATH/template/docker-compose-"$1".yml $DOCKER_PATH/docker-compose.yml
cp $DOCKER_PATH/template/Dockerfile $DOCKER_PATH/Dockerfile

sed -i "" "s/{ENV}/$1/g" $DOCKER_PATH/Dockerfile
sed -i "" "s/{DOMAIN}/$2/g" $DOCKER_PATH/docker-compose.yml
sed -i "" "s/{EMAIL}/$3/g" $DOCKER_PATH/docker-compose.yml

cd "$DOCKER_PATH"/../
SPRING_PROFILE_ACTIVE=test ./gradlew clean build
cp build/libs/*.jar docker/application.jar

cd docker
docker-compose up -d
