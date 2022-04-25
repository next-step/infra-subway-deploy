#!/bin/bash
# convention : common 스크립트 내에서 사용되는 모든 변수에는 prefix로 c_를  사용한다.
source $(dirname $0)/common/color.sh
source $(dirname $0)/common/print.sh

# Global 환경 변수
c_server_port=8080

c_root_path=$(dirname $0)/..
c_gradle_path=${c_root_path}/gradlew