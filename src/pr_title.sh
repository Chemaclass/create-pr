#!/bin/bash
set -o allexport

_CURRENT_DIR="$(dirname "${BASH_SOURCE[0]}")"
# shellcheck disable=SC1091
[ -f "$_CURRENT_DIR/pr_ticket.sh" ] && source "$_CURRENT_DIR/pr_ticket.sh"

# shellcheck disable=SC2155
function pr_title() {
    branch_name="$1"
    local ticket_key=$(pr_ticket::key "$branch_name")
    local ticket_number=$(pr_ticket::number "$branch_name")

    if [[ -z "$ticket_key" || -z "$ticket_number" ]]; then
      pr_title::normalize "$branch_name"
      return
    fi

    # Initialize prefix and parts as empty
    prefix=""
    part1=""
    part2=""
    part3=""

    # Remove the prefix if it starts with any prefix followed by '/'
    if [[ "$branch_name" =~ ^[^/]+/ ]]; then
        prefix=$(echo "$branch_name" | cut -d'/' -f1)
        branch_name="${branch_name#*/}"

        case "$prefix" in
            fix|bug|bugfix) prefix="Fix" ;;
            *)              prefix="" ;;
        esac
    fi
    # Extract and format parts of the branch_name
    part1=$(echo "$branch_name" | cut -d'-' -f1 | tr '[:lower:]' '[:upper:]')
    part2=$(echo "$branch_name" | cut -d'-' -f2)
    part3=$(echo "$branch_name" | cut -d'-' -f3- | tr '-' ' '| tr '_' ' ')

    # Ensure there is no duplicated "Fix"
    if [[ "$part3" =~ Fix || "$part3" =~ fix ]]; then
        prefix=""
    fi

    # Construct the final formatted title
    if [[ -n "$prefix" ]]; then
        part3="$(echo "$part3" | tr '[:upper:]' '[:lower:]')"
        echo "$part1-$part2 $prefix $part3"
    else
        part3="$(echo "${part3:0:1}" | tr '[:lower:]' '[:upper:]')${part3:1}"
        echo "$part1-$part2 $part3"
    fi
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
