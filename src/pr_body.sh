#!/bin/bash

_CURRENT_DIR="$(dirname "${BASH_SOURCE[0]}")"
# shellcheck disable=SC1091
[ -f "$_CURRENT_DIR/pr_format.sh" ] && source "$_CURRENT_DIR/pr_format.sh"

# shellcheck disable=SC2001
function format_pr_body() {
  local branch_name=$1
  local pr_template=$2
  local pr_body

  local ticket_key
  ticket_key=$(get_ticket_key "$branch_name")

  local ticket_number
  ticket_number=$(get_ticket_number "$branch_name")

  local with_link=false
  if [[ -n "${PR_TICKET_LINK_PREFIX}" && -n "${ticket_number}" ]]; then
    with_link=true
  fi

  # {{TICKET_LINK}}
  local ticket_link="Nope"
  if [[ "$with_link" == true ]]; then
    if [[ -z "$ticket_key" ]]; then
      ticket_link="${PR_TICKET_LINK_PREFIX}${ticket_number}"
    else
      ticket_link="${PR_TICKET_LINK_PREFIX}${ticket_key}-${ticket_number}"
    fi
    ticket_link="${PR_TICKET_PREFIX_TEXT}${ticket_link}"
  fi
  pr_body=$(perl -pe 's/<!--\s*{{\s*(.*?)\s*}}\s*-->/{{ $1 }}/g' "$pr_template")
  pr_body=$(echo "$pr_body" | sed "s|{{[[:space:]]*TICKET_LINK[[:space:]]*}}|$ticket_link|g")

  # {{BACKGROUND}}
  local background_text="Provide some context to the reviewer before jumping in the code."
  if [[ "$with_link" == true ]]; then
    background_text="Details in the ticket."
  fi
  pr_body=$(echo "$pr_body" | sed "s|{{[[:space:]]*BACKGROUND[[:space:]]*}}|$background_text|g")

  # Trim leading and trailing whitespace from pr_body
  pr_body=$(echo "$pr_body" | awk '{$1=$1};1')

  echo "$pr_body"
}
