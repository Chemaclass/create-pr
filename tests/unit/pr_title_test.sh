#!/bin/bash

function set_up() {
  export PR_TITLE_TEMPLATE="{{TICKET_KEY}}-{{TICKET_NUMBER}} {{PR_TITLE}}"

  source "$CREATE_PR_ROOT_DIR/src/pr_title.sh"
}

function test_pr_title_no_template() {
  export PR_TITLE_TEMPLATE=
  actual=$(pr_title "feat/TICKET-0000-my-new-1st-feature")

  assert_same "" "$actual"
}

function test_pr_title_custom_template_with_ticket_key_number_title() {
  export PR_TITLE_TEMPLATE='[{{TICKET_NUMBER}}-{{ TICKET_KEY }}]: {{  PR_TITLE  }} 🏗️'
  actual=$(pr_title "feat/TICKET-0000-my-new-2nd-feature")

  assert_same "[0000-TICKET]: My new 2nd feature 🏗️" "$actual"
}

function test_pr_title_custom_template_with_ticket_number_title() {
  skip
  export PR_TITLE_TEMPLATE='[{{TICKET_NUMBER}}]: {{  PR_TITLE  }} 🏗️'
  actual=$(pr_title "feat/123-my-new-2nd-feature")
#  assert_same "[123]: My new 2nd feature 🏗️" "$actual"
}

function test_pr_title_custom_template_with_ticket_key_title() {
  skip
  export PR_TITLE_TEMPLATE='[{{TICKET_KEY}}]: {{  PR_TITLE  }} 🏗️'
  actual=$(pr_title "feat/KEY-my-new-2nd-feature")
#  assert_same "[KEY]: My new 2nd feature 🏗️" "$actual"
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
  echo "bug"
}
