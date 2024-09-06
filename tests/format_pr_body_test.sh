#!/bin/bash

# shellcheck disable=SC2046
# shellcheck disable=SC2155

ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."

function set_up() {
  source "$ROOT_DIR/src/pr_format.sh"
}

function test_format_pr_body_link_with_PR_TICKET_LINK_PREFIX() {
  export PR_TICKET_LINK_PREFIX=https://your-company.atlassian.net/browse/

  local actual=$(format_pr_body "TICKET-123-my_branch-with-1-number" "$ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_contains "https://your-company.atlassian.net/browse/TICKET-123" "$actual"
}

function test_format_pr_body_link_without_PR_TICKET_LINK_PREFIX() {
  export PR_TICKET_LINK_PREFIX=

  local actual=$(format_pr_body "TICKET-123-my_branch" "$ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_not_contains "https://your-company.atlassian.net/browse/" "$actual"
  assert_contains "Nope" "$actual"
}

function test_format_pr_body_link_without_ticket_key() {
  export PR_TICKET_LINK_PREFIX=https://your-company.atlassian.net/browse/

  local actual=$(format_pr_body "123-my_branch" "$ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_not_contains "https://your-company.atlassian.net/browse/" "$actual"
  assert_contains "Nope" "$actual"
}

function test_format_pr_body_link_without_ticket_number() {
  export PR_TICKET_LINK_PREFIX=https://your-company.atlassian.net/browse/

  local actual=$(format_pr_body "TICKET-my_branch" "$ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_not_contains "https://your-company.atlassian.net/browse/" "$actual"
  assert_contains "Nope" "$actual"
}

function test_format_pr_body_link_without_pr_template() {
  export PR_TICKET_LINK_PREFIX=https://your-company.atlassian.net/browse/

  local actual=$(format_pr_body "TICKET-123-my_branch" "")

  assert_same "" "$actual"
}

function test_format_pr_body_link_with_branch_with_numbers_no_prefix() {
  export PR_TICKET_LINK_PREFIX=https://your-company.atlassian.net/browse/

  local actual=$(format_pr_body "TICKET-123-my-4-th-branch" "$ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_contains "https://your-company.atlassian.net/browse/TICKET-123" "$actual"
}

function test_format_pr_body_link_with_branch_with_numbers_with_prefix() {
  export PR_TICKET_LINK_PREFIX=https://your-company.atlassian.net/browse/

  local actual=$(format_pr_body "feat/TICKET-123-my-4-th-branch" "$ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_contains "https://your-company.atlassian.net/browse/TICKET-123" "$actual"
}

function test_format_pr_body_background_with_link() {
  export PR_TICKET_LINK_PREFIX=https://your-company.atlassian.net/browse/

  local actual=$(format_pr_body "feat/TICKET-123-my-4-th-branch" "$ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_not_contains "{{BACKGROUND}}" "$actual"
  assert_contains "Details in the ticket." "$actual"
}
