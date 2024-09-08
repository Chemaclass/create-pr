#!/bin/bash
set -o allexport

# shellcheck disable=SC2155

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

BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || error_and_exit "Failed to get the current branch name."
LABEL=${LABEL:-$(get_label "$BRANCH_NAME" "${PR_LABEL_MAPPING:-}")}
PR_TITLE=$(format_title "$BRANCH_NAME")
PR_BODY=$(format_pr_body "$BRANCH_NAME" "$PR_TEMPLATE")

export BASE_BRANCH
export ASSIGNEE
export BRANCH_NAME
export LABEL
export PR_TITLE
export PR_BODY
