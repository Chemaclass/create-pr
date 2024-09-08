#!/bin/bash

function set_up() {
  source "$CREATE_PR_ROOT_DIR/src/env_configuration.sh"
  source "$CREATE_PR_ROOT_DIR/src/pr_title.sh"
  source "$CREATE_PR_ROOT_DIR/src/pr_body.sh"
}

function test_pr_title_default_template() {
  actual=$(pr_title "feat/TICKET-0000-my-new-1st-feature")

  assert_same "TICKET-0000 My new 1st feature" "$actual"
}

function test_pr_title_custom_template() {
  export PR_TITLE_TEMPLATE='[{{TICKET_NUMBER}}-{{TICKET_KEY}}]: {{BRANCH_NAME}} 🏗️'
  actual=$(pr_title "feat/TICKET-0000-my-new-2nd-feature")

  assert_same "[0000-TICKET]: My new 2nd feature 🏗️" "$actual"
}

function test_pr_title_with_underscores_no_prefix() {
  actual=$(pr_title "add_pr_create_script")

  assert_same "Add Pr Create Script" "$actual"
}

function test_pr_title_with_underscores_with_prefix() {
  actual=$(pr_title "prefix/add_pr_create_script")

  assert_same "Add Pr Create Script" "$actual"
}

function test_pr_title_with_prefix_and_ticket_number() {
  actual=$(pr_title "prefix/27-add-pr-3-create_script")

  assert_same "Add pr 3 create Script" "$actual"
}

function test_pr_title_with_prefix_and_ticket_key() {
  actual="$(pr_title "feat/TICKET-my-branch_name")"

  assert_same "Ticket my branch Name" "$actual"
}

function test_pr_title_without_prefix_but_ticket() {
  actual=$(pr_title "TICKET-0000-add_pr_create_script")

  assert_same "TICKET-0000 Add pr create script" "$actual"
}

function test_pr_title_without_prefix_but_ticket_number() {
  actual=$(pr_title "0000-add_pr_create_script")

  assert_same "Add Pr Create Script" "$actual"
}

function test_pr_title_without_ticket() {
  actual=$(pr_title "add-pr-create_script")

  assert_same "Add pr create Script" "$actual"
}

# data_provider provider_no_prefix
function test_pr_title_remove_prefix() {
  local prefix=$1
  actual=$(pr_title "$prefix/TICKET-0000-my-new-3-feature")

  assert_same "TICKET-0000 My new 3 feature" "$actual"
}

function provider_no_prefix() {
  echo "feat"
  echo "feature"
  echo "_"
}

# data_provider provider_fix_prefix
function test_pr_title_with_fix_prefix() {
  local prefix=$1
  actual=$(pr_title "$prefix/TICKET-0000-something-was-broken")

  assert_same "TICKET-0000 Something was broken" "$actual"
}

function provider_fix_prefix() {
  echo "fix"
  echo "bug"
  echo "bugfix"
}
