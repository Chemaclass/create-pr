#!/bin/bash
set -euo pipefail

function main::create_pr() {
  validate::target_branch_exists
  validate::branch_has_commits
  validate::current_branch_is_not_target

  # Push the current branch
  if ! git push -u origin "$CURRENT_BRANCH"; then
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
  validate::glab_cli_is_installed

  local glab_command=(
    glab mr create
      --title "$PR_TITLE"
      --target-branch "$TARGET_BRANCH"
      --source-branch "$CURRENT_BRANCH"
      --assignee "$PR_ASSIGNEE"
      --reviewer "$PR_REVIEWER"
      --label "$PR_LABEL"
      --description "$PR_BODY"
  )

  if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
    glab_command+=("${EXTRA_ARGS[@]}")
  fi

  if ! "${glab_command[@]}"; then
    error_and_exit "Failed to create the Merge Request." \
      "Ensure you have the correct permissions and the repository is properly configured."
  fi
}

function main::create_pr_github() {
  validate::gh_cli_is_installed

  local gh_command=(
    gh pr create
      --title "$PR_TITLE"
      --base "$TARGET_BRANCH"
      --head "$CURRENT_BRANCH"
      --assignee "$PR_ASSIGNEE"
      --reviewer "$PR_REVIEWER"
      --label "$PR_LABEL"
      --body "$PR_BODY"
  )

  if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
    gh_command+=("${EXTRA_ARGS[@]}")
  fi

  if ! "${gh_command[@]}"; then
      error_and_exit "Failed to create the Pull Request." \
        "Ensure you have the correct permissions and the repository is properly configured."
  fi
}
