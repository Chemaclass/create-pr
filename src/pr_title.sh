#!/bin/bash
set -o allexport

_CURRENT_DIR="$(dirname "${BASH_SOURCE[0]}")"
# shellcheck disable=SC1091
[ -f "$_CURRENT_DIR/pr_ticket.sh" ] && source "$_CURRENT_DIR/pr_ticket.sh"

# shellcheck disable=SC2155
function pr_title() {
  local branch_name="$1"
  branch_name="${branch_name#*/}"
  local ticket_key=$(pr_ticket::key "$branch_name")
  local ticket_number=$(pr_ticket::number "$branch_name")

  if [[ -z "$ticket_key" || -z "$ticket_number" ]]; then
    pr_title::normalize "$branch_name"
    return
  fi

  # Initialize prefix and parts as empty
  local ticket_key=""
  local ticket_number=""
  local title=""

  # Extract and format parts of the branch_name
  ticket_key=$(echo "$branch_name" | cut -d'-' -f1 | tr '[:lower:]' '[:upper:]')
  ticket_number=$(echo "$branch_name" | cut -d'-' -f2)
  title=$(echo "$branch_name" | cut -d'-' -f3- | tr '-' ' '| tr '_' ' ')

  title="$(echo "${title:0:1}" | tr '[:lower:]' '[:upper:]')${title:1}"
  echo "$ticket_key-$ticket_number $title"
}

function pr_title::normalize() {
  input="$1"
  # Remove the prefix before the first '/'
  input="${input#*/}"
  # Remove leading digits followed by a hyphen (e.g., "27-")
  input="${input#[0-9]*-}"

  result=$(echo "$input" | awk '
      {
          gsub(/_/, " ", $0)  # Replace underscores with spaces
          for (i = 1; i <= NF; i++) {
              # Capitalize first letter and lowercase the rest
              $i = toupper(substr($i, 1, 1)) tolower(substr($i, 2))
          }
          gsub(/-/, " ", $0)  # Replace hyphens with spaces
          print
      }' | sed 's/[[:space:]]*$//')

  echo "$result"
}
