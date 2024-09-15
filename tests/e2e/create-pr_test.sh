#!/bin/bash

function set_up() {
  export APP_CREATE_PR_ROOT_DIR=.
  export REMOTE_URL="git@github.com:Chemaclass/create-pr.git"
  export BASE_BRANCH="main"
  export BRANCH_NAME="feat/ticket-123-my_branch-name"
  export PR_TEMPLATE_PATH=".github/PULL_REQUEST_TEMPLATE.md"
  export PR_TICKET_LINK_PREFIX="https://github.com/Chemaclass/create-pr/issues/"
  export PR_LINK_PREFIX_TEXT="Closes: "
  export PR_TITLE_TEMPLATE="{{TICKET_KEY}}-{{TICKET_NUMBER}} {{PR_TITLE}}"
  export PR_LABEL_MAPPING="default:enhancement;"

  SCRIPT="$CREATE_PR_ROOT_DIR/create-pr"
}

function test_success() {
  spy git
  spy gh

  assert_match_snapshot "$($SCRIPT)"
}

function test_script_with_debug() {
  spy git
  spy gh

  assert_match_snapshot "$($SCRIPT --debug)"
}
