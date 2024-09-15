#!/bin/bash
set -euo pipefail

# shellcheck disable=SC2034
declare -r CREATE_PR_VERSION="0.5.0"

CREATE_PR_ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")"
export CREATE_PR_ROOT_DIR

source "$CREATE_PR_ROOT_DIR/src/debug.sh"
source "$CREATE_PR_ROOT_DIR/src/helpers.sh"
source "$CREATE_PR_ROOT_DIR/src/validation.sh"
source "$CREATE_PR_ROOT_DIR/src/pr_ticket.sh"
source "$CREATE_PR_ROOT_DIR/src/pr_body.sh"
source "$CREATE_PR_ROOT_DIR/src/pr_label.sh"
source "$CREATE_PR_ROOT_DIR/src/pr_title.sh"
source "$CREATE_PR_ROOT_DIR/src/env_configuration.sh"
source "$CREATE_PR_ROOT_DIR/src/console_header.sh"
source "$CREATE_PR_ROOT_DIR/src/main.sh"

DEBUG=${DEBUG:-false}

while [[ $# -gt 0 ]]; do
  argument="$1"
  case $argument in
    --debug|--dry-run)
      DEBUG=true
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
    -t|--title)
      helpers::generate_branch_name "$2" "${3:-}"
      trap '' EXIT && exit 0
      ;;
    --help)
      console_header::print_help
      trap '' EXIT && exit 0
      ;;
  esac
  shift
done

PR_LABEL=${PR_LABEL:-${LABEL:-$(pr_label "$BRANCH_NAME" "${PR_LABEL_MAPPING:-}")}}
PR_TITLE=$(pr_title "$BRANCH_NAME")
PR_BODY=$(pr_body "$BRANCH_NAME" "$PR_TEMPLATE")

if [[ "$DEBUG" == true ]]; then
  dump "REMOTE_URL: $REMOTE_URL"
  dump "BRANCH_NAME: $BRANCH_NAME"
  dump "PR_USING_CLIENT: $PR_USING_CLIENT"
  dump "PR_TEMPLATE: $PR_TEMPLATE"
  dump "PR_LABEL: $PR_LABEL"
  dump "PR_TITLE: $PR_TITLE"
  dump "PR_BODY: $PR_BODY"
  exit 0
fi

export PR_LABEL
export PR_TITLE
export PR_BODY

main::create_pr

echo "Script finished successfully."
