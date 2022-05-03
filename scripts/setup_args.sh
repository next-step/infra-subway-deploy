#!/bin/bash

function parse_arguments() {
  for ARGUMENT in "$@"
  do
    KEY=$(echo "${ARGUMENT}" | cut -f1 -d=)

    KEY_LENGTH=${#KEY}
    VALUE="${ARGUMENT:$KEY_LENGTH+1}"

    export "${KEY}"="${VALUE}"
  done
}

function set_default_if_empty() {
  for i in "$@"
  do
    KEY=$(echo "${i%,*}" | cut -f1 -d=)
    ARGUMENT=${!KEY}
    DEFAULT_VALUE=${i#*,}

    if [[ -z "${ARGUMENT}" ]]
      then
        export "${KEY}"="${DEFAULT_VALUE}"
    fi
  done
}

function setup_java_args() {
    if [[ -f "${JAVA_ARGS_FILE}" ]]; then
      cd "${SHELL_SCRIPT_PATH}"
      source "${JAVA_ARGS_FILE}"
    fi

    if [[ -n "${JAVA_RUN_ARGS}" ]]; then
      cd "${SHELL_SCRIPT_PATH}"
      echo "JAVA_RUN_ARGS=\"${JAVA_RUN_ARGS}\"" >| "${JAVA_ARGS_FILE}"
    fi
}

cd "${SHELL_SCRIPT_PATH}"
source ./properties.sh
parse_arguments "${@}"
set_default_if_empty "${PROPERTIES[@]}"
setup_java_args
