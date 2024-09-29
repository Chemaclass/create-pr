#!/bin/bash
set -euo pipefail

function current_dir() {
  dirname "${BASH_SOURCE[1]}"
}

function current_filename() {
  basename "${BASH_SOURCE[1]}"
}

export CREATE_PR_ROOT_DIR=.
