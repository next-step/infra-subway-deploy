#!/bin/bash

./gradlew clean build --exclude-task test
docker build -t nextstep/reverse-proxy -f docker/nginx/Dockerfile .
docker build -t nextstep/app -f docker/app/Dockerfile .
