#!/bin/bash
# shellcheck disable=SC2317,SC2329

function test_check_os_linux() {
  unset _OS
  function uname() { echo "Linux"; }
  source "$CREATE_PR_ROOT_DIR/src/check_os.sh"
  local result="$_OS"
  unset -f uname
  assert_same "Linux" "$result"
}

function test_check_os_osx() {
  unset _OS
  function uname() { echo "Darwin"; }
  source "$CREATE_PR_ROOT_DIR/src/check_os.sh"
  local result="$_OS"
  unset -f uname
  assert_same "OSX" "$result"
}

function test_check_os_windows() {
  unset _OS
  function uname() { echo "MINGW64_NT-10.0"; }
  source "$CREATE_PR_ROOT_DIR/src/check_os.sh"
  local result="$_OS"
  unset -f uname
  assert_same "Windows" "$result"
}

function test_check_os_unknown() {
  unset _OS
  function uname() { echo "Solaris"; }
  source "$CREATE_PR_ROOT_DIR/src/check_os.sh"
  local result="$_OS"
  unset -f uname
  assert_same "Unknown" "$result"
}
