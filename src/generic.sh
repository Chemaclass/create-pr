#!/bin/bash

function error_and_exit() {
    echo "Error: $1" >&2
    exit 1
}

function validate_gh_cli_is_installed() {
  if ! command -v gh &> /dev/null; then
      error_and_exit "gh CLI is not installed. Please install it from $GH_CLI_INSTALLATION_URL and try again."
  fi
}

function validate_the_branch_has_commits() {
  if [ "$(git rev-list --count "$BRANCH_NAME")" -eq 0 ]; then
      error_and_exit "The current branch has no commits. Make sure the branch is not empty."
  fi
}

function validate_base_branch_exists() {
  if ! git show-ref --verify --quiet "refs/heads/$BASE_BRANCH"; then
    error_and_exit "Base branch '$BASE_BRANCH' does not exist. Please check the base branch name or create it."
  fi
}

