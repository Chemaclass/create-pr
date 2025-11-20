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

  main::run_after_creation_script
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

  main::run_after_creation_script
}

function main::run_after_creation_script() {
  # Skip if PR_RUN_AFTER_CREATION is not set or empty
  if [[ -z "${PR_RUN_AFTER_CREATION:-}" ]]; then
    return 0
  fi

  echo "Running post-creation script..."

  # Execute the command and capture exit status
  local exit_code=0
  eval "$PR_RUN_AFTER_CREATION" || exit_code=$?

  # Report failure but don't fail the overall PR creation
  if [[ $exit_code -ne 0 ]]; then
    echo "Warning: Post-creation script exited with code $exit_code, but PR was created successfully." >&2
    return 0
  fi

  echo "Post-creation script completed successfully."
  return 0
}
