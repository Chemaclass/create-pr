#!/bin/bash

# shellcheck disable=SC2155

function set_up() {
  PR_LINK_PREFIX_TEXT=""

  source "$CREATE_PR_ROOT_DIR/src/pr_body.sh"
}

function test_pr_body_link_with_PR_TICKET_LINK_PREFIX() {
  export PR_TICKET_LINK_PREFIX=https://your-ticket-system.com/

  local actual=$(pr_body "TICKET-123-my_branch-with-1-number"\
    "$CREATE_PR_ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_match_snapshot "$actual"
}

function test_pr_body_link_without_ticket_link_prefix() {
  export PR_TICKET_LINK_PREFIX=

  local actual=$(pr_body "TICKET-123-my_branch"\
    "$CREATE_PR_ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_match_snapshot "$actual"
}

function test_pr_body_link_without_ticket_key() {
  export PR_TICKET_LINK_PREFIX=https://your-ticket-system.com/

  local actual=$(pr_body "123-my_branch"\
    "$CREATE_PR_ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_match_snapshot "$actual"
}

function test_pr_body_link_with_pr_ticket_prefix_text() {
  export PR_TICKET_LINK_PREFIX=https://your-ticket-system.com/
  export PR_LINK_PREFIX_TEXT="Fixes: "

  local actual=$(pr_body "123-my_branch"\
    "$CREATE_PR_ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_match_snapshot "$actual"
}

function test_pr_body_link_without_ticket_number() {
  export PR_TICKET_LINK_PREFIX=https://your-ticket-system.com/

  local actual=$(pr_body "TICKET-my_branch"\
    "$CREATE_PR_ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_match_snapshot "$actual"
}

function test_pr_body_link_without_pr_template() {
  export PR_TICKET_LINK_PREFIX=https://your-ticket-system.com/

  local actual=$(pr_body "TICKET-123-my_branch" "")

  assert_same "PR_TEMPLATE is empty; therefore not a valid path." "$actual"
}

function test_pr_body_link_without_valid_pr_template_path() {
  export PR_TICKET_LINK_PREFIX=https://your-ticket-system.com/

  local actual=$(pr_body "TICKET-123-my_branch" "/non-existing-path")

  assert_same "/non-existing-path is not a valid template path." "$actual"
}

function test_pr_body_link_with_branch_with_numbers_no_prefix() {
  export PR_TICKET_LINK_PREFIX=https://your-ticket-system.com/

  local actual=$(pr_body "TICKET-123-my-4-th-branch"\
    "$CREATE_PR_ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_match_snapshot "$actual"
}

function test_pr_body_link_with_branch_with_numbers_and_prefix() {
  export PR_TICKET_LINK_PREFIX=https://your-ticket-system.com/

  local actual=$(pr_body "feat/TICKET-123-my-4-th-branch"\
    "$CREATE_PR_ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_match_snapshot "$actual"
}

function test_pr_body_background_without_link() {
  export PR_TICKET_LINK_PREFIX=

  local actual=$(pr_body "feat/TICKET-123-my-4-th-branch"\
    "$CREATE_PR_ROOT_DIR/.github/PULL_REQUEST_TEMPLATE.md")

  assert_match_snapshot "$actual"
}
