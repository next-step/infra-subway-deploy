#!/bin/bash
tty=`tty | awk -F"/dev/" '{print $2}'`
IP=`w | grep "$tty" | awk '{print $3}'`
export PROMPT_COMMAND='logger -p local0.debug "[USER]$(whoami) [IP]$IP [PID]$$ [PWD]`pwd` [COMMAND] $(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//" )"'

INPUT_LINE="local0.*  /var/log/command-0.log"
FILE="/etc/rsyslog.d/50-default.conf"

sudo grep -qF "$INPUT_LINE" "$FILE" || echo  "$INPUT_LINE" | sudo tee -a "$FILE"
#   local0.*                        @원격지서버IP

sudo service rsyslog restart

echo "PROMPT COMMAND"
