#!/bin/bash

# shellcheck disable=SC2046
# shellcheck disable=SC2155

ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."

function set_up() {
  source "$ROOT_DIR/src/pr_format.sh"
}

function test_get_ticket_key_default() {
  assert_equals "TICKET" "$(get_ticket_key "TICKET-123-my-branch_name")"
}

function test_get_ticket_key_with_prefix() {
  assert_equals "TICKET" "$(get_ticket_key "feat/TICKET-123-my-branch_name")"
}

function test_get_ticket_key_with_prefix_and_number_in_branch_name() {
  assert_equals "TICKET" "$(get_ticket_key "feat/TICKET-123-my-5-th-branch_name")"
}

function test_get_ticket_key_lower_upper_case() {
  assert_equals "TICKET" "$(get_ticket_key "Ticket-123-my-branch_name")"
}

function test_get_ticket_key_without_number_but_branch_prefix() {
  assert_equals "TICKET" "$(get_ticket_key "feat/TICKET-my-branch_name")"
}

function test_get_ticket_key_without_number_and_no_branch_prefix() {
  assert_equals "TICKET" "$(get_ticket_key "TICKET-my-branch_name")"
}

function test_get_ticket_key_with_numbers_in_branch_name() {
  assert_equals "TICKET" "$(get_ticket_key "TICKET-my-1-st-branch_name")"
}
