FROM openjdk:8
COPY application.jar application.jar
ENTRYPOINT ["java", "-server", "-jar", "-Duser.timezone=Asiz/Seoul", "-Dspring.profiles.active={env}", "application.jar"]
EXPOSE 8080
