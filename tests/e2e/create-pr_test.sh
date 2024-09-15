#!/bin/bash

function set_up() {
  export APP_CREATE_PR_ROOT_DIR=.
  export BASE_BRANCH="main"
  export BRANCH_NAME="feat/ticket-123-my_branch-name"
  export PR_TEMPLATE_PATH=".github/PULL_REQUEST_TEMPLATE.md"
  export PR_TICKET_LINK_PREFIX="https://github.com/Chemaclass/create-pr.sh/issues/"
  export PR_LINK_PREFIX_TEXT="Closes: "
  export PR_TITLE_TEMPLATE="{{TICKET_KEY}}-{{TICKET_NUMBER}} {{PR_TITLE}}"
  export PR_LABEL_MAPPING="default:enhancement;"

  SCRIPT="$CREATE_PR_ROOT_DIR/create-pr.sh"
}

function tear_down_after_script() {
  export DEBUG=false
}

function test_success() {
  spy git
  spy gh
  export DEBUG=false

  assert_match_snapshot "$($SCRIPT)"
}

function test_debug_success() {
  spy git
  spy gh
  export DEBUG=true

  assert_match_snapshot "$($SCRIPT)"
}
