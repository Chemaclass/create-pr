#!/bin/bash
set -o allexport

_CURRENT_DIR="$(dirname "${BASH_SOURCE[0]}")"
# shellcheck disable=SC1091
[ -f "$_CURRENT_DIR/pr_ticket.sh" ] && source "$_CURRENT_DIR/pr_ticket.sh"

function pr_title() {
  local branch_name="$1"
  branch_name="${branch_name#*/}"
  # Trim any Unicode characters from the branch name
  branch_name=$(printf '%s' "$branch_name" | LC_ALL=C tr -cd "$(printf '\t\n\r') -~")
  local ticket_key
  ticket_key=$(pr_ticket::key "$branch_name")

  local ticket_number
  ticket_number=$(pr_ticket::number "$branch_name")

  if [[ -z "$ticket_key" || -z "$ticket_number" ]]; then
    pr_title::without_ticket "$branch_name"
    return
  fi

  local title
  title=$(echo "$branch_name" | cut -d'-' -f3- | tr '-' ' '| tr '_' ' ')
  title="$(echo "${title:0:1}" | tr '[:lower:]' '[:upper:]')${title:1}"

  # Normalize the template by removing spaces around placeholders
  local normalized_template
  normalized_template=$(echo "$PR_TITLE_TEMPLATE" | sed -E 's/\{\{[[:space:]]*([^[:space:]]+)[[:space:]]*\}\}/{{\1}}/g')

  # Replace placeholders with actual values
  local formatted
  formatted="${normalized_template//\{\{TICKET_KEY\}\}/$ticket_key}"
  formatted="${formatted//\{\{TICKET_NUMBER\}\}/$ticket_number}"

  local new_title="$title"

  if [[ -n "$PR_TITLE_REMOVE_PREFIX" ]]; then
    # Split PR_TITLE_REMOVE_PREFIX into an array
    IFS=',' read -ra prefixes <<< "$PR_TITLE_REMOVE_PREFIX"
    # Loop through each prefix and remove it from the start if it matches
    for prefix in "${prefixes[@]}"; do
      # shellcheck disable=SC2001
      new_title="$(echo "$new_title" | sed -e "s/^${prefix}//I")"
    done

    # Trim leading whitespace and capitalize the first letter
    new_title=$(echo "$new_title" \
      | sed 's/^ *//' \
      | awk '{ print toupper(substr($0,1,1)) tolower(substr($0,2)) }')
  fi

  formatted="${formatted//\{\{PR_TITLE\}\}/$new_title}"

  echo "$formatted"
}

function pr_title::without_ticket() {
  input="$1"
  # Remove any Unicode characters from the input
  input=$(printf '%s' "$input" | LC_ALL=C tr -cd "$(printf '\t\n\r') -~")
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
