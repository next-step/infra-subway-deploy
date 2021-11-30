FROM openjdk:8-jdk

EXPOSE 8080
ADD ./build/libs/*.jar subway.jar

CMD ["java", "-jar", "-Dspring.profiles.active=prod", "subway.jar"]