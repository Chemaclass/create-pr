#!/bin/bash
set -o allexport

function helpers::generate_branch_name() {
  local input="$1"
  local prefix="${2:-feat}"

  local lowercase
  lowercase=$(echo "$input" | tr '[:upper:]' '[:lower:]')

  local branch_name
  branch_name=$(echo "$lowercase" | tr ' ' '-')

  echo "${prefix}/${branch_name}"
}
