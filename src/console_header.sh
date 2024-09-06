#!/bin/bash

function console_header::print_version() {
  printf "%s\n" "$CREATE_PR_VERSION"
}

function console_header::print_help() {
    cat <<EOF
create-pr.sh [arguments] [options]

Arguments:
  None

Options:
  --debug
    Print all executed shell commands to the terminal.

  -e|--env <file-path>
    Load a custom env file overriding the .env environment variables.

  --version
    Displays the current version.

  --help
    This message.

See source code: https://github.com/Chemaclass/create-pr.sh
EOF
}
