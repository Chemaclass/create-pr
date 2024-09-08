#!/bin/bash

function set_up() {
  export PR_TEMPLATE_DIR=".github/PULL_REQUEST_TEMPLATE.md"
  export PR_TICKET_LINK_PREFIX="https://github.com/Chemaclass/create-pr.sh/issues/"
  export PR_TICKET_PREFIX_TEXT="Closes: "
  export PR_LABEL_MAPPING="docs:documentation;\
    feat|feature:enhancement;\
    fix|bug|bugfix|hotfix:bug;\
    default:enhancement"

  SCRIPT="$CREATE_PR_ROOT_DIR/create-pr.sh"
}

function test_success() {
  spy git
  spy gh

  assert_match_snapshot "$($SCRIPT)"
}
