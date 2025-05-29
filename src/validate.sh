#!/bin/bash
set -o allexport

GH_CLI_INSTALLATION_URL="https://cli.github.com/"
GLAB_CLI_INSTALLATION_URL="https://gitlab.com/gitlab-org/cli/"

function error_and_exit() {
    echo "Error: $1" >&2
    exit 1
}

function validate::target_branch_exists() {
  if ! git show-ref --verify --quiet "refs/heads/$TARGET_BRANCH"; then
    error_and_exit "Base branch '$TARGET_BRANCH' does not exist. Please check the base branch name or create it."
  fi
}

function validate::branch_has_commits() {
  if [ "$(git rev-list --count "$CURRENT_BRANCH")" -eq 0 ]; then
    error_and_exit "The current branch has no commits. Make sure the branch is not empty."
  fi
}

function validate::current_branch_is_not_target() {
  if [ "$CURRENT_BRANCH" = "$TARGET_BRANCH" ]; then
    error_and_exit "You are on the same branch as target -> $CURRENT_BRANCH"
  fi
}

function validate::gh_cli_is_installed() {
  if ! command -v gh &> /dev/null; then
    error_and_exit "gh CLI is not installed. Please install it from $GH_CLI_INSTALLATION_URL and try again."
  fi
}

function validate::glab_cli_is_installed() {
  if ! command -v glab &> /dev/null; then
    error_and_exit "glab CLI is not installed. Please install it from $GLAB_CLI_INSTALLATION_URL and try again."
  fi
}
