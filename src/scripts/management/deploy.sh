#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << deploy scripts >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

COMMAND=$1

function runDb
{
        ssh in "~/db/start_mysql_container.sh"
}

function stopDb
{
        ssh in "~/db/stop_mysql_container.sh"
}

function runProxy
{
        ssh pubb "~/scripts/start_nginx_container.sh proxy:0.0.3"
}

function stopProxy
{
        ssh pubb "~/scripts/stop_nginx_container.sh"
}

function runApp
{
        ssh puba "~/scripts/start_app.sh"
        ssh pubb "~/scripts/start_app.sh"
}

function stopApp
{
        ssh puba "~/scripts/stop_app/sh"
        ssh pubb "~/scripts/stop_app/sh"
}

function init
{
        echo "INIT"
        # internal db
        stopDb
        runDb

        # public b nginx
"deploy.sh" 107L, 1997C                                                                           1,1           Top
#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


echo -e "${txtylw}=======================================${txtrst}"
echo -e "${txtgrn}  << deploy scripts >>${txtrst}"
echo -e "${txtylw}=======================================${txtrst}"

COMMAND=$1

function runDb
{
        ssh in "~/db/start_mysql_container.sh"
}

function stopDb
{
        ssh in "~/db/stop_mysql_container.sh"
}

function runProxy
{
        ssh pubb "~/scripts/start_nginx_container.sh proxy:0.0.3"
}

function stopProxy
{
        ssh pubb "~/scripts/stop_nginx_container.sh"
}

function runApp
{
        ssh puba "~/scripts/start_app.sh"
        ssh pubb "~/scripts/start_app.sh"
}

function stopApp
{
        ssh puba "~/scripts/stop_app/sh"
        ssh pubb "~/scripts/stop_app/sh"
}

function init
{
        echo "INIT"
        # internal db
        stopDb
        runDb

        # public b nginx
        stopProxy
        runProxy

        # public a, b repositoy
        echo "start public a subway app"
        ssh puba "~/scripts/clone_app.sh"
        ssh puba "~/scripts/pull_app.sh"
        ssh puba "~/scripts/stop_app.sh"
        ssh puba "~/scripts/start_app.sh"

        echo "start public b subway app"
        ssh pubb "~/scripts/clone_app.sh"
        ssh pubb "~/scripts/pull_app.sh"
        ssh pubb "~/scripts/stop_app.sh"
        ssh pubb "~/scripts/start_app.sh"
}

function main
{
        case $COMMAND in
                'help')
                        echo "$BASH_SOURCE [command]"
                        echo "----------------------"
                        echo "run_db            - mysql container 실행(internal)"
                        echo "stop_db           - mysql container 중지(internal)"
                        echo "run_proxy         - nginx container 실행(public b)"
                        echo "stop_proxy        - nginx container 중지(public b)"
                        echo "run_app           - subway app 실행(public a, b)"
                        echo "stop_app          - subway app 중지(public a, b)"
                        ;;
                'run_db')
                        runDb;;
                'stop_db')
                        stopDb;;
                'run_proxy')
                        runProxy;;
                'stop_proxy')
                        stopProxy;;
                'run_app')
                        runApp;;
                'stop_app')
                        stopApp;;
                'init')
                        init;;
        esac

}