#!/bin/bash
set -o allexport

function console_header::print_version() {
  printf "%s\n" "$CREATE_PR_VERSION"
}

function console_header::print_help() {
    cat <<EOF
create-pr [arguments] [options]

Arguments:
  None

Options:
  --debug
    Print all executed shell commands to the terminal.

  -e|--env <file-path>
    Load a custom env file overriding the .env environment variables.

  -t|--title <PR title> <branch prefix>
    Generate a branch name based on the PR title.
    <branch prefix> "feat" by default.

  --version
    Displays the current version.

  --help
    This message.

See source code: https://github.com/Chemaclass/create-pr
EOF
}
