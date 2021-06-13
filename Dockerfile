FROM java:8
VOLUME /tmp

# The application's jar file
# Add the application's jar to the container
ARG JAR_FILE=build/libs/*.jar

# Add the application's jar to the container
ADD ${JAR_FILE} subway-0.0.1-SNAPSHOT.jar

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/subway-0.0.1-SNAPSHOT.jar"]