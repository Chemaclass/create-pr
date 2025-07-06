#!/bin/bash

function set_up() {
  source "$CREATE_PR_ROOT_DIR/src/console_header.sh"
}

function test_console_header_print_version() {
  export CREATE_PR_VERSION="1.2.3"
  assert_same "1.2.3" "$(console_header::print_version)"
}

function test_console_header_print_help() {
  local actual
  actual=$(console_header::print_help)
  assert_match_snapshot "$actual"
}
