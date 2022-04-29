```sh
#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

DATABASE_SCRIPT_PATH=~/script/start-db.sh
WEBSERVER_SCRIPT_PATH=~/script/start-webserver.sh

function startDatabase() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e ">> Bastion -> Start database 🏃♂️ "

  if [ -z "$(ssh database docker ps -a -f "name=database")" ]; then
        ssh database ${DATABASE_SCRIPT_PATH}
  fi

  echo -e "${txtylw}=======================================${txtrst}"
}

function startWebServer() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e ">> Bastion -> Start webserver 🏃♂️ "

  if [ -z "$(ssh webserver pgrep java)" ]; then
        ssh webserver ${WEBSERVER_SCRIPT_PATH} main prod
  fi

  echo -e "${txtylw}=======================================${txtrst}"
}

startDatabase;
startWebServer;
```