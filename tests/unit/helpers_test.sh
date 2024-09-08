#!/bin/bash

function set_up() {
  source "$CREATE_PR_ROOT_DIR/src/helpers.sh"
}

function test_helpers_generate_branch_name_default_prefix() {
  actual=$(helpers::generate_branch_name "Add new feature")

  assert_same "feat/add-new-feature" "$actual"
}

function test_helpers_generate_branch_name_with_prefix() {
  actual=$(helpers::generate_branch_name "Broken feature" "bug")

  assert_same "bug/broken-feature" "$actual"
}
