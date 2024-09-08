#!/bin/bash

set -o allexport
# shellcheck source=/dev/null
[[ -f ".env" ]] && source .env set
set +o allexport

APP_CREATE_PR_ROOT_DIR=$(git rev-parse --show-toplevel) || error_and_exit "This directory is not a git repository"
PR_TICKET_PREFIX_TEXT=${PR_TICKET_PREFIX_TEXT:-""}
PR_TEMPLATE_DIR=${PR_TEMPLATE_DIR:-".github/PULL_REQUEST_TEMPLATE.md"}
PR_TEMPLATE="$APP_CREATE_PR_ROOT_DIR/$PR_TEMPLATE_DIR"
[ -z "$PR_TEMPLATE" ] && error_and_exit "PR template file $PR_TEMPLATE not found."

BASE_BRANCH=${BASE_BRANCH:-"main"}
ASSIGNEE=${ASSIGNEE:-"@me"}
