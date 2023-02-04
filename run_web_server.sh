#!/bin/sh
git pull
git checkout step2
./gradlew clean build

nohup java -jar -Dspring.profiles.active=prod ./build/libs/subway-0.0.1-SNAPSHOT.jar &

#docker restart -d -p 80:80 -p 443:443 --name proxy nextstep/reverse-proxy:0.0.2
docker restart proxy
docker restart local_db
