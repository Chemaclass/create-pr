#!/bin/bash
# shellcheck disable=SC2034

function set_up() {
  source "$CREATE_PR_ROOT_DIR/src/pr_ticket.sh"
}

function test_pr_ticket_number_start_with_number() {
  assert_same "123" "$(pr_ticket::number "123-TICKET-my-branch_name")"
}

function test_pr_ticket_number_after_ticket_key() {
  assert_same "123" "$(pr_ticket::number "TICKET-123-my-branch_name")"
}

function test_pr_ticket_number_with_prefix() {
  assert_same "123" "$(pr_ticket::number "feat/TICKET-123-my-branch_name")"
}

function test_pr_ticket_number_without_prefix_but_prefix() {
  assert_same "123" "$(pr_ticket::number "feat/123-my-branch_name")"
}

function test_pr_ticket_number_with_prefix_and_number_in_branch_name() {
  assert_same "123" "$(pr_ticket::number "feat/TICKET-123-my-4-th-branch_name")"
}

function test_pr_ticket_number_lower_upper_case() {
  assert_same "123" "$(pr_ticket::number "Ticket-123-my-branch_name")"
}

function test_pr_ticket_number_with_numbers_in_branch_name() {
  assert_same "123" "$(pr_ticket::number "Ticket-123-my-2-nd-branch_name")"
}

function test_pr_ticket_number_without_number() {
  assert_empty "$(pr_ticket::number "creating-my-branch_name")"
}

function test_pr_ticket_number_with_number_not_in_first_nor_second_pos() {
  assert_empty "$(pr_ticket::number "creating-my-2-nd-branch_name")"
}

function test_pr_ticket_number_with_prefix_and_number_not_in_first_nor_second_pos() {
  assert_empty "$(pr_ticket::number "feat/creating-my-2-nd-branch_name")"
}
