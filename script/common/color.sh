#!/bin/bash
## 색깔 변수 설정
c_color_white='\033[1;37m'  # White
c_color_red='\033[1;31m'    # Red
c_color_yellow='\033[1;33m' # Yellow
c_color_purple='\033[1;35m' # Purple
c_color_green='\033[1;32m'  # Green
c_color_gray='\033[1;30m'   # Gray

## 상황별 색깔 변수
c_color_default=${c_color_white}   # 기본값
c_color_error=${c_color_red}       # 에러
c_color_success=${c_color_green}   # 성공
c_color_warn=${c_color_yellow}     # 경고
c_color_processing=${c_color_purple} # 진행중
c_color_info=${c_color_gray}       # 정보
