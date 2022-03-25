FROM java:8

LABEL maintainer="com8599@gmail.com"
VOLUME /tmp
EXPOSE 443

ARG JAR_FILE=build/libs/subway-0.0.1-SNAPSHOT.jar

ADD ${JAR_FILE} subway.jar

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "-Dspring.profiles.active=prod", "/subway.jar"]