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

  if [[ "$PR_USING_CLIENT" == "gitlab" ]]; then
    main::create_pr_gitlab
  else
    main::create_pr_github
  fi
}

function main::create_pr_gitlab() {
  validate_glab_cli_is_installed
  : "${EXTRA_ARGS:=()}"

  if glab mr create --title "$PR_TITLE" \
                      --target-branch "$BASE_BRANCH" \
                      --source-branch "$BRANCH_NAME" \
                      --assignee "$PR_ASSIGNEE" \
                      --label "$PR_LABEL" \
                      --description "$PR_BODY" \
                      "${EXTRA_ARGS[@]}" \
  ; then
    echo "Merge Request created successfully."
  else
    error_and_exit "Failed to create the Merge Request." \
      "Ensure you have the correct permissions and the repository is properly configured."
  fi
}

function main::create_pr_github() {
  validate_gh_cli_is_installed
  : "${EXTRA_ARGS:=()}"

  # Create the PR with the specified options
  if ! gh pr create --title "$PR_TITLE" \
                    --base "$BASE_BRANCH" \
                    --head "$BRANCH_NAME" \
                    --assignee "$PR_ASSIGNEE" \
                    --label "$PR_LABEL" \
                    --body "$PR_BODY" \
                    "${EXTRA_ARGS[@]}" \
  ; then
      error_and_exit "Failed to create the pull request."\
        "Ensure you have the correct permissions and the repository is properly configured."
  fi
}
