# create-pr.sh

A bash script that helps create your PRs.
It normalised the PR title, description, assignee by default and initial label based on your branch name.

> It requires https://cli.github.com/

## Installation

Download the latest `single executable script` on the [Releases page](https://github.com/Chemaclass/bash-create-pr/releases), or build it yourself. You can validate the file's checksum to validate that it wasn't altered. The checksum for each release is on each release on GitHub.

To build the project yourself, you can do it manually or execute it `./build.sh`.

## How to use it?

Customizable envs:
- `PR_TEMPLATE_DIR`
  - `PR_TEMPLATE_DIR=.github/PULL_REQUEST_TEMPLATE.md` [example](.github/PULL_REQUEST_TEMPLATE.md)
  - Placeholders:
    - You can define them inside a comment to avoid rendering them when creating a PR without this script
        - eg `<!-- {{ TICKET_LINK }} -->`
    - `{{ TICKET_LINK }}`
      - Uses `PR_TICKET_LINK_PREFIX` appending the ticket key and number to form the full URL
    - `{{ BACKGROUND }}`
      - if link is found: `Details in the ticket.`
      - if link is not found: `Provide some context to the reviewer before jumping in the code.`

- `PR_LINK_PREFIX_TEXT`
  - Text to display if the link does not contain a `TICKET_KEY`
  - eg `Closes: https://github.com/Chemaclass/create-pr.sh/issues/27`
    - branch: `feat/27-my-branch-name`
    - `PR_TICKET_LINK_PREFIX="https://github.com/Chemaclass/create-pr.sh/issues/"`
    - `PR_LINK_PREFIX_TEXT="Closes :"`
- `PR_TITLE_TEMPLATE`
  - Enable custom PR title with placeholders: `{{TICKET_NUMBER}}`, `{{TICKET_KEY}}`, `{{PR_TITLE}}`
  - eg `PR_TITLE_TEMPLATE="{{TICKET_KEY}}-{{TICKET_NUMBER}} {{PR_TITLE}}"`
- `PR_LABEL`
  - Define a label for the PR
  - eg `PR_LABEL=enhancement`
  - If empty then extract label from the branch's prefix - see `PR_LABEL_MAPPING`
- `PR_LABEL_MAPPING`
  - Define a custom mapping from prefix branches to GitHub label
  - eg `PR_LABEL_MAPPING="feat:enhancement; fix|bug:bug; default:extra"`
    - eg `feat/your-branch` -> `enhancement` label
    - eg `fix/your-branch` -> `bug` label
    - eg `bug/your-branch` -> `bug` label
    - eg `unkown/your-branch` -> `extra` label
- `PR_ASSIGNEE` or `@me` by default
- `BASE_BRANCH` or `main` by default

### HINTS

- Add to your composer, npm or similar a script pointing to the `create-pr.sh`
- You can use the [PULL_REQUEST_TEMPLATE](./.github/PULL_REQUEST_TEMPLATE.md) from this project as example

### Contribute

Suggestions, ideas and PRs are more than welcome here!
Please, Check out our [CONTRIBUTING.md](.github/CONTRIBUTING.md) guidelines.
