#!/bin/bash
set -euo pipefail

function main::create_pr() {
  validate_base_branch_exists
  validate_the_branch_has_commits
  # Push the current branch
  if ! git push -u origin "$BRANCH_NAME"; then
      error_and_exit "Failed to push the current branch to the remote repository."\
        "Please check your git remote settings."
  fi

  validate_gh_cli_is_installed
  # Create the PR with the specified options
  if ! gh pr create --title "$PR_TITLE" \
                    --base "$BASE_BRANCH" \
                    --head "$BRANCH_NAME" \
                    --assignee "$ASSIGNEE" \
                    --label "$LABEL" \
                    --body "$PR_BODY"; then
      error_and_exit "Failed to create the pull request."\
        "Ensure you have the correct permissions and the repository is properly configured."
  fi
}
