#!/bin/bash

ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."

function set_up() {
  source "$ROOT_DIR/src/pr_format.sh"
}

function test_get_ticket_number_default() {
  assert_same "123" "$(get_ticket_number "TICKET-123-my-branch_name")"
}

function test_get_ticket_number_with_prefix() {
  assert_same "123" "$(get_ticket_number "feat/TICKET-123-my-branch_name")"
}

function test_get_ticket_number_without_prefix_but_prefix() {
  assert_same "123" "$(get_ticket_number "feat/123-my-branch_name")"
}

function test_get_ticket_number_with_prefix_and_number_in_branch_name() {
  assert_same "123" "$(get_ticket_number "feat/TICKET-123-my-4-th-branch_name")"
}

function test_get_ticket_number_lower_upper_case() {
  assert_same "123" "$(get_ticket_number "Ticket-123-my-branch_name")"
}

function test_get_ticket_number_with_numbers_in_branch_name() {
  assert_same "123" "$(get_ticket_number "Ticket-123-my-2-nd-branch_name")"
}
