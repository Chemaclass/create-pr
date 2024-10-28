#!/bin/bash
# shellcheck disable=SC2034

function set_up() {
  source "$CREATE_PR_ROOT_DIR/src/pr_ticket.sh"
}

function test_pr_ticket_number_default() {
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

# data_provider provide_ticket_number_only_at_the_beginning
function test_pr_ticket_number_only_at_the_beginning() {
  local branch_name="$1"

  assert_empty "$(pr_ticket::number "$branch_name")"
}

function provide_ticket_number_only_at_the_beginning() {
  echo "creating-my-branch_name"
  echo "creating-my-2-nd-branch_name"
  echo "TICKET-my-2-nd-branch_name"
  echo "feat/creating-my-2-nd-branch_name"
  echo "feat/TICKET-my-2-nd-branch_name"
}
