```sh
#!/bin/bash

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

function startDockerDatabase() {
  echo -e "${txtylw}=======================================${txtrst}"
  echo -e ">> Database -> startDockerDatabase 🏃♂️ "

  docker container rm -f $(docker ps -a -f "name=database")
  sudo docker run -d -p 3306:3306 --name database brainbackdoor/data-subway:0.0.1

  echo -e "${txtylw}=======================================${txtrst}"
}
```


