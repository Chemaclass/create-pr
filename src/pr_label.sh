#!/bin/bash

# Find the default label based on the branch prefix
function pr_label() {
  local branch_name=$1
  local mapping=${2:-"feat|feature:enhancement;\
  fix|bug|bugfix:bug;\
  docs|documentation:documentation;\
  default:enhancement"}
  # Remove empty spaces due to indentation
  mapping=${mapping// /}
  # Extract the prefix (the part before the first slash or dash)
  local prefix
  prefix=$(echo "$branch_name" | sed -E 's@^([^/-]+).*@\1@')
  # Default label
  local default_label="enhancement"

  # Loop through the mapping string to find a match
  IFS=';' # Split mapping entries by semicolon
  for entry in $mapping; do
    # Split each entry into keys and value
    IFS=':' read -r keys value <<< "$entry"

    # Check if the prefix matches any of the keys
    IFS='|' # Split keys by pipe symbol
    for key in $keys; do
      if [[ "$prefix" == "$key" ]]; then
        echo "$value"
        return
      fi
    done

    # Set the default label if found
    if [[ "$keys" == "default" ]]; then
      default_label="$value"
    fi
  done

  # Return the default label if no match is found
  echo "$default_label"
}
