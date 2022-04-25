#!/bin/bash

c_line_start="${c_color_yellow}===> ${c_color_default}"

c_print_start() {
  echo -e ""
  echo -e "${c_line_start}${c_color_processing}$1 Starting...🏎️${c_color_default}"
}

c_print_end() {
  echo -e "${c_line_start}${c_color_success}$1 End...✅️${c_color_default}"
}
