#!/bin/bash

GH_CLI_INSTALLATION_URL="https://cli.github.com/"
GLAB_CLI_INSTALLATION_URL="https://gitlab.com/gitlab-org/cli/"

function error_and_exit() {
    echo "Error: $1" >&2
    exit 1
}

function validate_base_branch_exists() {
  local base_branch=$1
  if ! git show-ref --verify --quiet "refs/heads/$base_branch"; then
    error_and_exit "Base branch '$base_branch' does not exist. Please check the base branch name or create it."
  fi
}

function validate_the_branch_has_commits() {
  local branch_name=$1
  if [ "$(git rev-list --count "$branch_name")" -eq 0 ]; then
      error_and_exit "The current branch has no commits. Make sure the branch is not empty."
  fi
}

function validate_gh_cli_is_installed() {
  if ! command -v gh &> /dev/null; then
      error_and_exit "gh CLI is not installed. Please install it from $GH_CLI_INSTALLATION_URL and try again."
  fi
}

function validate_glab_cli_is_installed() {
  if ! command -v glab &> /dev/null; then
      error_and_exit "glab CLI is not installed. Please install it from $GLAB_CLI_INSTALLATION_URL and try again."
  fi
}
