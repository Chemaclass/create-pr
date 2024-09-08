#!/bin/bash
set -o allexport

_CURRENT_DIR="$(dirname "${BASH_SOURCE[0]}")"
# shellcheck disable=SC1091
[ -f "$_CURRENT_DIR/pr_ticket.sh" ] && source "$_CURRENT_DIR/pr_ticket.sh"

# shellcheck disable=SC2001
function pr_body() {
  local branch_name=$1
  local pr_template=$2
  local result

  local ticket_key
  ticket_key=$(pr_ticket::key "$branch_name")

  local ticket_number
  ticket_number=$(pr_ticket::number "$branch_name")

  local with_link=false
  if [[ -n "${PR_TICKET_LINK_PREFIX:-}" && -n "${ticket_number}" ]]; then
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
    ticket_link="${PR_LINK_PREFIX_TEXT}${ticket_link}"
  fi
  result=$(perl -pe 's/<!--\s*{{\s*(.*?)\s*}}\s*-->/{{ $1 }}/g' "$pr_template")
  result=$(echo "$result" | sed "s|{{[[:space:]]*TICKET_LINK[[:space:]]*}}|$ticket_link|g")

  # {{BACKGROUND}}
  local background_text="Provide some context to the reviewer before jumping in the code."
  if [[ "$with_link" == true ]]; then
    background_text="Details in the ticket."
  fi
  result=$(echo "$result" | sed "s|{{[[:space:]]*BACKGROUND[[:space:]]*}}|$background_text|g")

  # Trim leading and trailing whitespace from result
  result=$(echo "$result" | awk '{$1=$1};1')

  echo "$result"
}
