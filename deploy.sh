# 자주 사용하는 값 변수에 저장
REPOSITORY=/home/ubuntu/nextstep
PROJECT_DIRECTORY=infra-subway-deploy
BUILD_LOACATION=build/libs
JAR_NAME=$(ls -tr $REPOSITORY/$PROJECT_DIRECTORY/$BUILD_LOACATION/ | grep jar | tail -n 1)
LOG_LOCATION=log/debug.log
PROFILE=prod
BRANCH=$1

# 실행 파라미터 출력
# echo $1
# echo $#

# 실행 파라미터들을 배열로 저장 후 출력
# args=("$@")
# echo ${args[0]}

# $@ 이용한모든 파라미터 출력
# echo $@


# 파라미터 검증
if [ $# -eq 0 ] ; then
      echo "Warning: no git branch arguments"
   exit 0
else
  check_df
fi

echo "> git branch: $BRANCH"


# git clone 받은 위치로 이동
cd $REPOSITORY/$PROJECT_DIRECTORY

# yeojiin 브랜치의 최신 내용 받기
echo "> Git Pull"
git pull origin $BRANCH


# github branch 변경이 있는 경우
function check_df() {
  git fetch
  master=$(git rev-parse $BRANCH)
  remote=$(git rev-parse origin $BRANCH)

  if [[ $master == $remote ]]; then
    echo -e "[$(date)] Nothing changed"
    exit 0
  fi
}




# 빌드 위치로 이동
cd $REPOSITORY/$PROJECT_DIRECTORY

# build 수행
echo "> project build start"
./gradlew build

# jar 위치로 이동
cd $REPOSITORY/$PROJECT_DIRECTORY/$BUILD_LOACATION


CURRENT_PID=$(pgrep -f ${JAR_NAME})

echo "> 현재 구동중인 어플리케이션pid: $CURRENT_PID"

# 함수 작성
kill_current_application( ) {
        echo "> kill -15 $CURRENT_PID"
        kill -15 $CURRENT_PID
        sleep 5
}


if [ -z "$CURRENT_PID" ]; then
        echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
        kill_current_application
fi

echo "> 새 애플리케이션 배포"
echo "> jar name: $JAR_NAME"
nohup java -jar -Dspring.profiles.active=$PROFILE $REPOSITORY/$PROJECT_DIRECTORY/$BUILD_LOACATION/$JAR_NAME 1> $REPOSITORY/$PROJECT_DIRECTORY/$LOG_LOCATION 2>&1 &

echo "새 애플리케이션 배포 완료"
echo "로그 시작 =======================>"
tail -500f $REPOSITORY/$PROJECT_DIRECTORY/$LOG_LOCATION



