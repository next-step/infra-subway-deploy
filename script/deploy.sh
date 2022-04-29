#!/bin/bash


source /home/ubuntu/infra-subway-deploy/script/init.sh

move_to_repo;
check_df;
build;
kill_and_start;
