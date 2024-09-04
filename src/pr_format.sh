#!/bin/bash

# shellcheck disable=SC2155

function format_title() {
    branch_name="$1"
    local ticket_key=$(get_ticket_key "$branch_name")
    local ticket_number=$(get_ticket_number "$branch_name")

    if [[ -z "$ticket_key" || -z "$ticket_number" ]]; then
      normalize_pr_title "$branch_name"
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

function normalize_pr_title() {
  input="$1"
  input="${input#*/}"

  echo "$input" | awk '
      {
          gsub(/_/, " ", $0)  # Replace underscores with spaces
          for (i = 1; i <= NF; i++) {
              # Capitalize first letter and lowercase the rest
              $i = toupper(substr($i, 1, 1)) tolower(substr($i, 2))
          }
          gsub(/-/, " ", $0)  # Replace hyphens with spaces
          print
      }' | sed 's/[[:space:]]*$//'
}

function get_ticket_number() {
  branch_name=$1
  echo "$branch_name" | grep -oE "[0-9]+" | head -n 1
}

function get_ticket_key() {
  branch_name=$1

  # Check if the branch name contains a '/'
  if [[ "$branch_name" == *"/"* ]]; then
    # Try to extract the pattern "KEY-NUMBER" and stop after the first occurrence
    ticket_key=$(echo "$branch_name" | grep -oE "[A-Za-z]+-[0-9]+" | head -n 1 | sed 's/-[0-9]*$//')
  else
    ticket_key=$(echo "$branch_name" | grep -oE "^[A-Za-z]+" | head -n 1)
  fi

  # If no ticket key is found, ensure there's no ticket-like pattern and return empty
  if [[ -z "$ticket_key" ]]; then
    if ! echo "$branch_name" | grep -qE "[A-Za-z]+-[0-9]+"; then
      echo ""
      return
    fi
  fi

  echo "$ticket_key" | tr '[:lower:]' '[:upper:]'
}



# Find the default label based on the branch prefix
function find_default_label() {
    local branch_name=$1

    # Extract the prefix (the part before the first slash or dash)
    # shellcheck disable=SC2155
    local prefix=$(echo "$branch_name" | sed -E 's@^([^/-]+).*@\1@')

    case "$prefix" in
        feat|feature)
            echo "enhancement"
            ;;
        fix|bug|bugfix)
            echo "bug"
            ;;
#        refactor|refactoring)
#            echo "refactoring"
#            ;;
        docs|documentation)
            echo "documentation"
            ;;
        *)
            echo "enhancement"
            ;;
    esac
}

function format_pr_body() {
  local branch_name=$1
  local pr_template=$2
  local pr_body

  local ticket_key
  ticket_key=$(get_ticket_key "$branch_name")

  local ticket_number
  ticket_number=$(get_ticket_number "$branch_name")

  if [[ -z "${PR_TICKET_LINK_PREFIX}" || -z "${ticket_key}" || -z "${ticket_number}" ]]; then
    # Remove the section and the following ticket line
    pr_body=$(sed "s|{{TICKET_LINK}}|Nope|g" "$pr_template")
  else
    # Combine PR_TICKET_LINK_PREFIX with the ticket key and number
    local full_link="${PR_TICKET_LINK_PREFIX}${ticket_key}-${ticket_number}"
    # Replace {{TICKET_LINK}} with the full Ticket link
    pr_body=$(sed "s|{{TICKET_LINK}}|$full_link|g" "$pr_template")
  fi
  # Trim leading and trailing whitespace from pr_body
  pr_body=$(echo "$pr_body" | awk '{$1=$1};1')

  echo "$pr_body"
}
