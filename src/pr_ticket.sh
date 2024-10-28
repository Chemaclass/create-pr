#!/bin/bash
set -o allexport

# $1 = branch_name
function pr_ticket::number() {
  branch_name=$1

  # Remove optional prefix and split the branch name by hyphens
  stripped_branch=${branch_name#*/}
  # shellcheck disable=SC2206
  parts=(${stripped_branch//-/ })

  # Check if the first or second part contains a number and print it; otherwise, print an empty string
  if [[ ${parts[0]} =~ ^[0-9]+$ ]]; then
    echo "${parts[0]}"
  elif [[ ${parts[1]} =~ ^[0-9]+$ ]]; then
    echo "${parts[1]}"
  else
    echo ""
  fi
}

# $1 = branch_name
function pr_ticket::key() {
  branch_name=$1

  # Check if the branch name contains a '/'
  if [[ "$branch_name" == *"/"* ]]; then
    # Extract the part after the first '/' and process it
    branch_suffix="${branch_name#*/}"
    # Try to extract the pattern "KEY-NUMBER" and stop after the first occurrence
    ticket_key=$(echo "$branch_suffix" | grep -oE "[A-Za-z]+-[0-9]+" | head -n 1 | sed 's/-[0-9]*$//')

    # If no ticket key is found, ensure there's no ticket-like pattern and use the prefix if it's uppercase
    if [[ -z "$ticket_key" ]]; then
      first_part=$(echo "$branch_name" | cut -d'/' -f2 | grep -oE "^[A-Z]+")
      if [[ -n "$first_part" ]]; then
        ticket_key="$first_part"
      fi
    fi
  else
    # For branch names without '/'
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
