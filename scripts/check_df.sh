git fetch
BRANCH=step3

master=$(git rev-parse $BRANCH)
remote=$(git rev-parse origin/$BRANCH)

if [[ $master == $remote ]]; then
  echo -e "[$(date)] 변경된 내용이 없습니다. 😫"
  exit 0
fi
echo -e "[$(date)] 업데이트 내용이 있습니다. 🤩"
