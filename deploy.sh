echo 'deploy start'

nohup java -jar -Dspring.profiles.active=prod ./build/libs/subway-0.0.1-SNAPSHOT.jar 1> production.log 2>&1  &