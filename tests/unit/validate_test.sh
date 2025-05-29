#!/bin/bash

function set_up() {
  source "$CREATE_PR_ROOT_DIR/src/validate.sh"
}

function test_validate_target_branch_exists_uses_target_branch_variable() {
  export TARGET_BRANCH="non-existent-branch"
  export CURRENT_BRANCH="some-branch"
  local output
  output=$(validate::target_branch_exists 2>&1 >/dev/null || true)
  assert_same "Error: Base branch 'non-existent-branch' does not exist. Check the base branch name or create it."\
    "$output"
}
