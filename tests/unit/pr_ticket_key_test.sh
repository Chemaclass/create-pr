#!/bin/bash

# shellcheck disable=SC2046
# shellcheck disable=SC2155

function set_up() {
  source "$CREATE_PR_ROOT_DIR/src/pr_ticket.sh"
}

function test_pr_ticket_key_default() {
  assert_same "TICKET" "$(pr_ticket::key "TICKET-123-my-branch_name")"
}

function test_pr_ticket_key_with_prefix() {
  assert_same "TICKET" "$(pr_ticket::key "feat/TICKET-123-my-branch_name")"
}

function test_pr_ticket_key_with_prefix_and_number_in_branch_name() {
  assert_same "TICKET" "$(pr_ticket::key "feat/TICKET-123-my-5-th-branch_name")"
}

function test_pr_ticket_key_lower_upper_case() {
  assert_same "TICKET" "$(pr_ticket::key "Ticket-123-my-branch_name")"
}

function test_pr_ticket_key_without_number_and_no_branch_prefix() {
  assert_same "TICKET" "$(pr_ticket::key "TICKET-my-branch_name")"
}

function test_pr_ticket_key_with_numbers_in_branch_name() {
  assert_same "TICKET" "$(pr_ticket::key "TICKET-my-1-st-branch_name")"
}

function test_pr_ticket_key_without_number_but_branch_prefix() {
  assert_same "TICKET" "$(pr_ticket::key "feat/TICKET-my-branch_name")"
}
