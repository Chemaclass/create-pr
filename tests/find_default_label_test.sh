#!/bin/bash

# shellcheck disable=SC2046
# shellcheck disable=SC2155

ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."

function set_up() {
  source "$ROOT_DIR/src/pr_format.sh"
}

function test_find_default_label_default() {
  assert_same "enhancement" $(find_default_label "TICKET-123-my-branch_name")
}

function test_find_default_label_enhancement() {
  assert_same "enhancement" $(find_default_label "feat/TICKET-123-my-branch_name")
  assert_same "enhancement" $(find_default_label "feature/TICKET-123-my-branch_name")
}

function test_find_default_label_bug() {
  assert_same "bug" $(find_default_label "fix/TICKET-123-my-branch_name")
  assert_same "bug" $(find_default_label "bug/TICKET-123-my-branch_name")
  assert_same "bug" $(find_default_label "bugfix/TICKET-123-my-branch_name")
}

#function test_find_default_label_refactoring() {
#  assert_same "refactoring" $(find_default_label "refactor/TICKET-123-my-branch_name")
#  assert_same "refactoring" $(find_default_label "refactoring/TICKET-123-my-branch_name")
#}

function test_find_default_label_documentation() {
  assert_same "documentation" $(find_default_label "docs/TICKET-123-my-branch_name")
  assert_same "documentation" $(find_default_label "documentation/TICKET-123-my-branch_name")
}
