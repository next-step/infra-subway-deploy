REPOSITORY=/build/libs
CURRENT_PID=0
LOG_FILE=log

function pull() {
  echo -e ""
  echo -e ">> Pull Request <<"
  git pull origin master
}

function gradleBuild() {
  echo -e ""
  echo -e ">> gradle build <<"
  ./gradlew clean build
}

function jar() {
    echo -e ""
    echo -e ">> jar repository <<"
    cd $REPOSITORY
}

function getPid() {
  echo -e ""
  echo -e ">> pid <<"
  CURRENT_PID=$(pgrep -f java)
}

function killProcess() {
  echo -e ""
  echo -e ">> kill process <<"
  kill -9 $CURRENT_PID
}

function deploy() {
    echo -e ""
    echo -e ">> deploy <<"
    nohub java -jar -Dspring.profiles.active=prod subway-0.0.1-SNAPSHOT.jar
}


echo -e " ============ script ============"
pull;
gradleBuild;
getPid;
if [ -z "$CURRENT_PID" ]; then
	echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
	killProcess
fi
deploy;