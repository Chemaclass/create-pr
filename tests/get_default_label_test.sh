#!/bin/bash

# shellcheck disable=SC2046
# shellcheck disable=SC2155

ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."

function set_up() {
  source "$ROOT_DIR/src/pr_format.sh"
}

function test_get_default_label_default() {
  assert_same "enhancement" $(get_default_label "TICKET-123-my-branch_name")
}

function test_get_default_label_enhancement() {
  assert_same "enhancement" $(get_default_label "feat/TICKET-123-my-branch_name")
  assert_same "enhancement" $(get_default_label "feature/TICKET-123-my-branch_name")
}

function test_get_default_label_bug() {
  assert_same "bug" $(get_default_label "fix/TICKET-123-my-branch_name")
  assert_same "bug" $(get_default_label "bug/TICKET-123-my-branch_name")
  assert_same "bug" $(get_default_label "bugfix/TICKET-123-my-branch_name")
}

function test_get_default_label_documentation() {
  assert_same "documentation" $(get_default_label "docs/TICKET-123-my-branch_name")
  assert_same "documentation" $(get_default_label "documentation/TICKET-123-my-branch_name")
}

function test_get_default_label_custom_mapping() {
  local mapping="default:extra;feat|feature:enhancement;fix|bug|bugfix:bug"

  assert_same "enhancement" $(get_default_label "feat/TICKET-123-my-branch_name" "$mapping")
  assert_same "enhancement" $(get_default_label "feature/TICKET-123-my-branch_name" "$mapping")

  assert_same "bug" $(get_default_label "fix/TICKET-123-my-branch_name" "$mapping")
  assert_same "bug" $(get_default_label "bug/TICKET-123-my-branch_name" "$mapping")
  assert_same "bug" $(get_default_label "bugfix/TICKET-123-my-branch_name" "$mapping")

  assert_same "extra" $(get_default_label "unknown/TICKET-123-my-branch_name" "$mapping")
}
