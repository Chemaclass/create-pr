#!/bin/bash

function set_up() {
  export PR_TEMPLATE_PATH=".github/PULL_REQUEST_TEMPLATE.md"
  export PR_TICKET_LINK_PREFIX="https://github.com/Chemaclass/create-pr.sh/issues/"
  export PR_LINK_PREFIX_TEXT="Closes: "
  export PR_TITLE_TEMPLATE="{{TICKET_KEY}}-{{TICKET_NUMBER}} {{PR_TITLE}}"
  export PR_LABEL_MAPPING="default:enhancement;"

  SCRIPT="$CREATE_PR_ROOT_DIR/create-pr.sh"
}

function test_success() {
  spy git
  spy gh

  assert_match_snapshot "$($SCRIPT)"
}
