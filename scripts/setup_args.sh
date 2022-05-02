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

source properties.sh
parse_arguments "${@}"
set_default_if_empty "${PROPERTIES[@]}"
