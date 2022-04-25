#!/bin/bash

function rotate_log() {
        LOG_DIRECTORY="/home/ubuntu/nextstep/infra-subway-deploy/logs"

        SERVER_NAME="subway"
        LOG_FILENM="$SERVER_NAME.log"

        DATE_TIME=`date +'%y%m%d_%H%M%S'`
        NOHUP_LOG_FILENM="${SERVER_NAME}_${DATE_TIME}.log"

        cp ${LOG_DIRECTORY}/${LOG_FILENM} ${LOG_DIRECTORY}/${NOHUP_LOG_FILENM}
        cat /dev/null > ${LOG_DIRECTORY}/${LOG_FILENM}
}

rotate_log
