FROM openjdk:8
COPY subway-0.0.1-SNAPSHOT.jar application.jar
ENTRYPOINT ["java", "-server", "-Duser.timezone=Asiz/Seoul", "-Dspring.profiles.active=prod"]
EXPOSE 8080
