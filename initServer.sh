#!/bin/bash

echo -e "======================================="
echo -e " 서버 중지 후 재시작시 필요한 설정들을 합니다"
echo -e "======================================="

echo -e ">>>>> 모든 docker 컨테이너를 시작합니다. "
docker start $(docker ps -a -q)

echo -e ">>>>>  java application 을 실행합니다. "
java -jar -Dspring.profiles.active=prod ./build/libs/subway-0.0.1-SNAPSHOT.jar &

