#!/bin/bash

function set_up() {
  SCRIPT="$CREATE_PR_ROOT_DIR/create-pr.sh"
}

function test_success() {
  spy git
  spy gh

  assert_match_snapshot "$($SCRIPT)"
}
