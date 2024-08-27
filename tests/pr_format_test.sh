#!/bin/bash

# shellcheck disable=SC2046
# shellcheck disable=SC2155

ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."

function set_up() {
  source "$ROOT_DIR/src/pr_format.sh"
}

function test_format_title_without_prefix() {
  actual=$(format_title "TICKET-0000-add_pr_create_script")

  assert_equals "TICKET-0000 Add Pr Create Script" "$actual"
}

# data_provider provider_no_prefix
function test_format_title_remove_prefix() {
  local prefix=$1
  actual=$(format_title "$prefix/TICKET-0000-my-new-feature")

  assert_equals "TICKET-0000 My new feature" "$actual"
}

function provider_no_prefix() {
  local directories=("feat" "feature" "_")
  echo "${directories[@]}"
}

# data_provider provider_fix_prefix
function test_format_title_with_fix_prefix() {
  local prefix=$1
  actual=$(format_title "$prefix/TICKET-0000-something-was-broken")

  assert_equals "TICKET-0000 Fix something was broken" "$actual"
}

# data_provider provider_fix_prefix
function test_format_title_with_fix_prefix_and_bug_in_branch_name() {
  local prefix=$1
  actual=$(format_title "$prefix/TICKET-0000-bug-something-was-broken")

  assert_equals "TICKET-0000 Fix bug something was broken" "$actual"
}

# data_provider provider_fix_prefix
function test_format_title_with_fix_prefix_and_fix_in_branch_name() {
  local prefix=$1
  actual=$(format_title "$prefix/TICKET-0000-fix-something-was-broken")

  assert_equals "TICKET-0000 Fix something was broken" "$actual"
}

function provider_fix_prefix() {
  local directories=("fix" "bug" "bugfix")
  echo "${directories[@]}"
}

function test_get_ticket_number_default() {
  assert_equals "123" "$(get_ticket_number "TICKET-123-my-branch_name")"
}

function test_get_ticket_number_with_prefix() {
  assert_equals "123" "$(get_ticket_number "feat/TICKET-123-my-branch_name")"
}

function test_get_ticket_number_lower_upper_case() {
  assert_equals "123" "$(get_ticket_number "Ticket-123-my-branch_name")"
}

function test_get_ticket_key_default() {
  assert_equals "TICKET" "$(get_ticket_key "TICKET-123-my-branch_name")"
}

function test_get_ticket_key_with_prefix() {
  assert_equals "TICKET" "$(get_ticket_key "feat/TICKET-123-my-branch_name")"
}

function test_get_ticket_key_lower_upper_case() {
  assert_equals "TICKET" "$(get_ticket_key "Ticket-123-my-branch_name")"
}

function test_find_default_label_default() {
  assert_equals "enhancement" $(find_default_label "TICKET-123-my-branch_name")
}

function test_find_default_label_enhancement() {
  assert_equals "enhancement" $(find_default_label "feat/TICKET-123-my-branch_name")
  assert_equals "enhancement" $(find_default_label "feature/TICKET-123-my-branch_name")
}

function test_find_default_label_bug() {
  assert_equals "bug" $(find_default_label "fix/TICKET-123-my-branch_name")
  assert_equals "bug" $(find_default_label "bug/TICKET-123-my-branch_name")
  assert_equals "bug" $(find_default_label "bugfix/TICKET-123-my-branch_name")
}

function test_find_default_label_refactoring() {
  assert_equals "refactoring" $(find_default_label "refactor/TICKET-123-my-branch_name")
  assert_equals "refactoring" $(find_default_label "refactoring/TICKET-123-my-branch_name")
}

function test_find_default_label_documentation() {
  assert_equals "documentation" $(find_default_label "docs/TICKET-123-my-branch_name")
  assert_equals "documentation" $(find_default_label "documentation/TICKET-123-my-branch_name")
}

function test_format_pr_body_with_link_prefix() {
  export LINK_PREFIX=https://your-company.atlassian.net/browse/

  local actual=$(format_pr_body "TICKET" "123" "$ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_contains "https://your-company.atlassian.net/browse/TICKET-123" "$actual"
}

function test_format_pr_body_without_link_prefix() {
  export LINK_PREFIX=

  local actual=$(format_pr_body "TICKET" "123" "$ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_not_contains "https://your-company.atlassian.net/browse/TICKET-123" "$actual"
  assert_string_starts_with "## 🤔 Background" "$actual"
}