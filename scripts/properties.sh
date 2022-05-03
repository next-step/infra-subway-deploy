#!/bin/bash

PROPERTIES=(
"EXECUTION_PATH,$(dirname "$(pwd)")"
"SHELL_SCRIPT_PATH,$(dirname "$0")"
"MODULE_NAME,subway"
"REMOTE_NAME,origin"
"BRANCH_NAME,seokhyoenchoi"
"ENVIRONMENT,prod"
"JAVA_ARGS_FILE,java_args.sh"

"txtrst,'\033[1;37m'" # White
"txtred,'\033[1;31m'" # Red
"txtylw,'\033[1;33m'" # Yellow
"txtpur,'\033[1;35m'" # Purple
"txtgrn,'\033[1;32m'" # Green
"txtgra,'\033[1;30m'" # Gray
)
