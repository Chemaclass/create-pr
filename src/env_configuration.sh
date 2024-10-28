#!/bin/bash
set -o allexport

# shellcheck source=/dev/null
[[ -f ".env" ]] && source .env set
set +o allexport

APP_CREATE_PR_ROOT_DIR=${APP_CREATE_PR_ROOT_DIR:-"$(git rev-parse --show-toplevel)"} \
  || error_and_exit "This directory is not a git repository"
PR_LINK_PREFIX_TEXT=${PR_LINK_PREFIX_TEXT:-""}
PR_TICKET_LINK_PREFIX=${PR_TICKET_LINK_PREFIX:-""}
PR_TEMPLATE_PATH=${PR_TEMPLATE_PATH:-".github/PULL_REQUEST_TEMPLATE.md"}
PR_TEMPLATE="$APP_CREATE_PR_ROOT_DIR/$PR_TEMPLATE_PATH"
PR_TITLE_TEMPLATE=${PR_TITLE_TEMPLATE:-"{{TICKET_KEY}}-{{TICKET_NUMBER}} {{PR_TITLE}}"}
PR_TITLE_REMOVE_PREFIX=${PR_TITLE_REMOVE_PREFIX:-"be"}
PR_ASSIGNEE=${PR_ASSIGNEE:-${ASSIGNEE:-"@me"}}
TARGET_BRANCH=${TARGET_BRANCH:-"main"}
CURRENT_BRANCH=${CURRENT_BRANCH:-"$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"} \
  || error_and_exit "Failed to get the current branch name."

REMOTE_URL=${REMOTE_URL:-"$(git config --get remote.origin.url)"}
if [[ "$REMOTE_URL" == *"github.com"* ]]; then
  PR_USING_CLIENT="github"
elif [[ "$REMOTE_URL" == *"gitlab.com"* ]]; then
  PR_USING_CLIENT="gitlab"
else
  echo "Unsupported $REMOTE_URL. Please submit a PR or an issue - so we can work on it."
  exit
fi

export REMOTE_URL
export PR_USING_CLIENT
export PR_TITLE_TEMPLATE
export PR_TITLE_REMOVE_PREFIX
export PR_TEMPLATE
export PR_ASSIGNEE
export TARGET_BRANCH
export CURRENT_BRANCH
