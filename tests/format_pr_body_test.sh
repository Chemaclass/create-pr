#!/bin/bash

# shellcheck disable=SC2046
# shellcheck disable=SC2155

ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."

function set_up() {
  source "$ROOT_DIR/src/pr_format.sh"
}

function test_format_pr_body_with_PR_TICKET_LINK_PREFIX() {
  export PR_TICKET_LINK_PREFIX=https://your-company.atlassian.net/browse/

  local actual=$(format_pr_body "TICKET-123-my_branch" "$ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_contains "https://your-company.atlassian.net/browse/TICKET-123" "$actual"
}

function test_format_pr_body_without_PR_TICKET_LINK_PREFIX() {
  export PR_TICKET_LINK_PREFIX=

  local actual=$(format_pr_body "TICKET-123-my_branch" "$ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_not_contains "https://your-company.atlassian.net/browse/" "$actual"
  assert_contains "Nope" "$actual"
}

function test_format_pr_body_without_ticket_key() {
  export PR_TICKET_LINK_PREFIX=https://your-company.atlassian.net/browse/

  local actual=$(format_pr_body "123-my_branch" "$ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_not_contains "https://your-company.atlassian.net/browse/" "$actual"
  assert_contains "Nope" "$actual"
}

function test_format_pr_body_without_ticket_number() {
  export PR_TICKET_LINK_PREFIX=https://your-company.atlassian.net/browse/

  local actual=$(format_pr_body "TICKET-my_branch" "$ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_not_contains "https://your-company.atlassian.net/browse/" "$actual"
  assert_contains "Nope" "$actual"
}

function test_format_pr_body_without_pr_template() {
  export PR_TICKET_LINK_PREFIX=https://your-company.atlassian.net/browse/

  local actual=$(format_pr_body "TICKET-123-my_branch" "")

  assert_equals "" "$actual"
}

function test_format_pr_body_with_branch_with_numbers() {
  export PR_TICKET_LINK_PREFIX=https://your-company.atlassian.net/browse/

  local actual=$(format_pr_body "feat/TICKET-123-my-4-th-branch" "$ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_contains "https://your-company.atlassian.net/browse/TICKET-123" "$actual"
}
