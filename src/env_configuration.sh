#!/bin/bash
set -o allexport

# shellcheck source=/dev/null
[[ -f ".env" ]] && source .env set
set +o allexport

APP_CREATE_PR_ROOT_DIR=$(git rev-parse --show-toplevel) || error_and_exit "This directory is not a git repository"
PR_LINK_PREFIX_TEXT=${PR_LINK_PREFIX_TEXT:-""}
PR_TICKET_LINK_PREFIX=${PR_TICKET_LINK_PREFIX:-""}
PR_TEMPLATE_PATH=${PR_TEMPLATE_PATH:-".github/PULL_REQUEST_TEMPLATE.md"}
PR_TEMPLATE="$APP_CREATE_PR_ROOT_DIR/$PR_TEMPLATE_PATH"
[ -z "$PR_TEMPLATE" ] && error_and_exit "PR template file $PR_TEMPLATE not found."

PR_TITLE_TEMPLATE="${PR_TITLE_TEMPLATE:-'{{TICKET_KEY}}-{{TICKET_NUMBER}} {{PR_TITLE}}'}"
PR_ASSIGNEE=${ASSIGNEE:-${PR_ASSIGNEE:-"@me"}}
BASE_BRANCH=${BASE_BRANCH:-"main"}
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || error_and_exit "Failed to get the current branch name."

export PR_TITLE_TEMPLATE
export PR_ASSIGNEE
export BASE_BRANCH
export BRANCH_NAME
