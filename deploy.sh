## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

BRANCH=$1
PROFILE=$2
SUBWAY_PATH=/home/ubuntu/infra-subway-deploy
PID=0

## 조건 설정
if [[ $# -ne 2 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
    echo -e ""
    echo -e "${txtgrn} $0 브랜치이름(minzzang) ${txtred}{ prod | dev }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi

function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)

  if [[ "$master" == "$remote" ]]
  then
    echo -e "[$(date)] Nothing to do!!!"
    exit 0
  fi
}

function pull() {
  echo -e ""
  echo -e ">> Pull Request 🏃♂️ "
  git checkout $BRANCH
  git pull
}

function build() {
  echo -e ""
  echo -e ">> Build"
  ./gradlew clean build
}

function findPid() {
  echo -e ""
  echo -e ">> Find Pid"
  PID=$(lsof -t -i :8080)
  echo -e "pid : $PID"
}

function killProcess() {
  echo -e ""
  echo -e ">> Kill Process"
  if [[ $PID -eq 0 ]]
  then
    echo -e "not found process"
  else
    kill -2 $PID
    echo -e "kill process, pid : $PID"
  fi
}

function deploy() {
  echo -e ""
  echo -e ">> Deploy"
  jarName=$(find $SUBWAY_PATH/build/ -name "*.jar")
  echo -e "jarName : $jarName"

  nohup java -jar -Dspring.profiles.active=$PROFILE jarName
  1> ~/subway.log 2>&1 &

  echo -e ""
  echo -e ">> Deploy Success"
}

function start() {
  check_df;
  pull;
  build;
  findPid;
  killProcess;
  deploy;
}

start;
