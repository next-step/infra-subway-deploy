FROM openjdk:8-jdk-alpine

#언어설정
ENV LANG ko_KR.UTF-8
ENV LANGUAGE ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8

LABEL maintainer="jhh992000@gmail.com"

#Timezone을 한국표준시간으로 적용
RUN ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime && echo Asia/Seoul > /etc/timezone

#디렉토리 생성
WORKDIR /app/webapp/infra-subway

#애플리케이션 빌드파일 복사
ARG JAR_FILE=build/libs/subway-*.jar
COPY ${JAR_FILE} /app/webapp/infra-subway/subway.jar

#실행환경 Profile 값
ARG SPRING_PROFILES_ACTIVE
RUN echo $SPRING_PROFILES_ACTIVE
ENV SPRING_PROFILES_ACTIVE=$SPRING_PROFILES_ACTIVE

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app/webapp/infra-subway/subway.jar"]