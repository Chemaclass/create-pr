#!/bin/bash

function set_up() {
  source "$CREATE_PR_ROOT_DIR/src/main.sh"
}

function test_main_run_after_creation_script_executes_when_set() {
  PR_RUN_AFTER_CREATION="echo 'test script executed'"

  local output
  output=$(main::run_after_creation_script 2>&1)

  assert_matches "Running post-creation script..." "$output"
  assert_matches "test script executed" "$output"
}

function test_main_run_after_creation_script_does_not_execute_when_empty() {
  PR_RUN_AFTER_CREATION=""

  local output
  output=$(main::run_after_creation_script 2>&1)

  assert_empty "$output"
}

function test_main_run_after_creation_script_shows_warning_on_failure() {
  PR_RUN_AFTER_CREATION="false"

  local output
  output=$(main::run_after_creation_script 2>&1)

  assert_matches "Running post-creation script..." "$output"
  assert_matches "Warning: Post-creation script failed, but PR was created successfully." "$output"
}

function test_main_run_after_creation_script_can_access_environment_variables() {
  CURRENT_BRANCH="feature-branch"
  PR_RUN_AFTER_CREATION='echo "Branch: $CURRENT_BRANCH"'

  local output
  output=$(main::run_after_creation_script 2>&1)

  assert_matches "Branch: feature-branch" "$output"
}
