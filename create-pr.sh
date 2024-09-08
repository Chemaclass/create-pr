#!/bin/bash
set -euo pipefail

# shellcheck disable=SC2034
declare -r CREATE_PR_VERSION="0.4.0"

CREATE_PR_ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")"
export CREATE_PR_ROOT_DIR

source "$CREATE_PR_ROOT_DIR/src/generic.sh"
source "$CREATE_PR_ROOT_DIR/src/env_configuration.sh"
source "$CREATE_PR_ROOT_DIR/src/console_header.sh"
source "$CREATE_PR_ROOT_DIR/src/pr_format.sh"
source "$CREATE_PR_ROOT_DIR/src/dev/debug.sh"

while [[ $# -gt 0 ]]; do
  argument="$1"
  case $argument in
    --debug)
      set -x
      ;;
    -e|--env)
      # shellcheck disable=SC1090
      source "$2"
      shift
      ;;
    -v|--version)
      console_header::print_version
      trap '' EXIT && exit 0
      ;;
    --help)
      console_header::print_help
      trap '' EXIT && exit 0
      ;;
  esac
  shift
done

BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || error_and_exit "Failed to get the current branch name."
LABEL=${LABEL:-$(get_label "$BRANCH_NAME" "${PR_LABEL_MAPPING:-}")}
PR_TITLE=$(format_title "$BRANCH_NAME")
PR_BODY=$(format_pr_body "$BRANCH_NAME" "$PR_TEMPLATE")

main::create_pr

echo "Pull request created successfully."
