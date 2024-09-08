#!/bin/bash

# shellcheck disable=SC2046
# shellcheck disable=SC2155

function set_up() {
  source "$CREATE_PR_ROOT_DIR/src/pr_format.sh"
}

function test_get_label_default() {
  assert_same "enhancement" $(get_label "TICKET-123-my-branch_name")
}

function test_get_label_default_enhancement() {
  assert_same "enhancement" $(get_label "feat/TICKET-123-my-branch_name")
  assert_same "enhancement" $(get_label "feature/TICKET-123-my-branch_name")
}

function test_get_label_default_bug() {
  assert_same "bug" $(get_label "fix/TICKET-123-my-branch_name")
  assert_same "bug" $(get_label "bug/TICKET-123-my-branch_name")
  assert_same "bug" $(get_label "bugfix/TICKET-123-my-branch_name")
}

function test_get_label_default_documentation() {
  assert_same "documentation" $(get_label "docs/TICKET-123-my-branch_name")
  assert_same "documentation" $(get_label "documentation/TICKET-123-my-branch_name")
}

function test_get_label_default_custom_mapping() {
  local mapping="default:extra; feat|feature:enhancement; fix|bug|bugfix:bug"

  assert_same "enhancement" $(get_label "feat/TICKET-123-my-branch_name" "$mapping")
  assert_same "enhancement" $(get_label "feature/TICKET-123-my-branch_name" "$mapping")

  assert_same "bug" $(get_label "fix/TICKET-123-my-branch_name" "$mapping")
  assert_same "bug" $(get_label "bug/TICKET-123-my-branch_name" "$mapping")
  assert_same "bug" $(get_label "bugfix/TICKET-123-my-branch_name" "$mapping")

  assert_same "extra" $(get_label "unknown/TICKET-123-my-branch_name" "$mapping")
}
