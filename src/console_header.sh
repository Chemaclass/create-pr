#!/bin/bash
set -o allexport

function console_header::print_version() {
  printf "%s\n" "$CREATE_PR_VERSION"
}

function console_header::print_help() {
    cat <<EOF
create-pr [arguments] [options]

Arguments:
  * GitHub: https://cli.github.com/manual/gh_pr_create
  * GitLab: https://gitlab.com/gitlab-org/cli/-/tree/main/docs/source/mr

Options:
  --debug
    Print all executed shell commands to the terminal

  --dry-run
    Display the used data without creating the PR

  -e|--env <file-path>
    Load a custom env file overriding the .env environment variables

  -t|--title <PR title> <branch prefix>
    Generate a branch name based on the PR title
    <branch prefix> "feat" by default

  -v|--version
    Displays the current version

  -h|--help
    This message

See source code: https://github.com/Chemaclass/create-pr
EOF
}
