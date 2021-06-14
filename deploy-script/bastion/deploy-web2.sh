#!/bin/sh

TARGET_DEPLOY_TCP=tcp://web2:2375
DOCKER_APP_NAME=infra-subway
DOCKER_HOST=${TARGET_DEPLOY_TCP} docker-compose -p ${DOCKER_APP_NAME} -f docker-compose.yml down
DOCKER_HOST=${TARGET_DEPLOY_TCP} docker-compose -p ${DOCKER_APP_NAME} -f docker-compose.yml pull
DOCKER_HOST=${TARGET_DEPLOY_TCP} docker-compose -p ${DOCKER_APP_NAME} -f docker-compose.yml up -d