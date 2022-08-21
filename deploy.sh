#! /bin/sh

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

SOURCE_DIR=$1
BRANCH=$2

echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << 스크립트 🧐 >>${txtrst}"
echo -e "${txtgrn} $0 브랜치 이름 ${BRANCH} ${txred}"
echo -e "${txtylw}=======================================${txtrst}"

#echo "data now : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)" >> check_test.txt


## 프로젝트로 이동
cd $SOURCE_DIR

check_param_source_dir() {
  if [ -z "$SOURCE_DIR" ];
  then
          echo "첫 번째 파라미터로 소스 경로를지정해 주세요!"
          exit 0
  fi
}


## branch 명을 파라미터로 넘겼는지 체크
check_param_branch() {
  if [ -z "$BRANCH" ];
  then
	  echo "두 번째 파라미터로 branch 명을 지정해 주세요!"
	  exit 0
  fi
}

## 변경 사항 있는지 체크
check_df() {
  git fetch
  git checkout $BRANCH
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin/$BRANCH)
  echo $master
  echo $remote

  if [ $master = $remote ]
  then
    echo -e "[$(date)] Nothing to do!!! "
    exit 0
  fi
}

## 저장소 pull
pull() {
	echo -e ""
	echo -e ">> Pull Request >>"
	git pull origin ${BRANCH}
}

## gradle build
build() {
	echo -e ""
	echo -e ">> Gradle Build >>"
	./gradlew clean build
}

## 프로세스 pid를 찾는 명령어
findPid() {
	PID=`ps -ef | grep subway-0.0.1-SNAPSHOT.jar | awk '{print $2; exit}'`
	echo ${PID} " => PID를  찾았습니다."
}

PID=$(findPid);
echo $PID

## 프로세스를 종료하는 명령어
killProcess() {
	KILL_PID=$1
	kill -9 $KILL_PID
	echo $KILL_PID "=> 웹 기동을 중지합니다"
}

# gradle 재기동

restart() {
	nohup java -jar -Dspring.profiles.active=prod build/libs/subway-0.0.1-SNAPSHOT.jar
	echo "웹 재기동..."
}

check_param_source_dir;
check_param_branch;
check_df;

pull;
build;
killProcess $PID;
restart;