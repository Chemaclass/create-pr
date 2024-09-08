# create-pr.sh

A bash script that helps create your PRs.
It normalised the PR title, description, assignee by default and initial label based on your branch name.

> It requires https://cli.github.com/ (currently only supports GitHub)

## Installation

Download the latest `single executable script` on the [Releases page](https://github.com/Chemaclass/bash-create-pr/releases), or build it yourself.

In case you download the executable file from releases' GitHub project, you can check the file's checksum to validate that it was not altered. The checksum for each release is on each release on GitHub.

To build the project yourself, execute the script `./build.sh` and move the resulting `bin/create-pr.sh` script wherever you want.

## How to use it?

The script is customizable via `.env` variables. See [.env.example](.env.example).

### PR_TEMPLATE_PATH

Define the path to locate the PR template. See [template example](.github/PULL_REQUEST_TEMPLATE.md).

#### Example

```bash
PR_TEMPLATE_PATH=.github/PULL_REQUEST_TEMPLATE.md
```

#### Placeholders

- `{{ TICKET_LINK }}`
    - Uses `PR_TICKET_LINK_PREFIX` appending the ticket key and number to form the full URL
- `{{ BACKGROUND }}`
    - if the link is found: `Details in the ticket`
    - if the link is not found: `Provide some context to the reviewer before jumping in the code`
- You can define them inside a comment (to avoid rendering the placeholders when creating a PR without this script)
    - eg `<!-- {{ TICKET_LINK }} -->`

### PR_LINK_PREFIX_TEXT

Text to display if the link does not contain a `TICKET_KEY`.

#### Example

Branch name: `feat/27-my-branch-name`

```bash
PR_TICKET_LINK_PREFIX="https://github.com/Chemaclass/create-pr.sh/issues/"
PR_LINK_PREFIX_TEXT="Closes: "
```

- Result: `Closes: https://github.com/Chemaclass/create-pr.sh/issues/27`

### PR_TITLE_TEMPLATE

Enable custom PR title with placeholders:

- `{{TICKET_NUMBER}}`
- `{{TICKET_KEY}}`
- `{{PR_TITLE}}`

#### Example

```bash
PR_TITLE_TEMPLATE="{{TICKET_KEY}}-{{TICKET_NUMBER}} {{PR_TITLE}}"
```

### PR_LABEL

> Alias: LABEL

Define a label for the PR.

#### Example

```bash
PR_LABEL=enhancement
```

If empty, extract the label from the branch's prefix - see `PR_LABEL_MAPPING`.

### PR_LABEL_MAPPING

Define a mapping from prefix branches to GitHub label.

#### Example

```bash
PR_LABEL_MAPPING="docs:documentation;\
  feat|feature:enhancement;\
  fix|bug|bugfix|hotfix:bug;\
  default:enhancement"
```

- eg `docs/your-branch` -> `documentation` label
- eg `feat/your-branch` -> `enhancement` label
- eg `fix/your-branch` -> `bug` label
- eg `bug/your-branch` -> `bug` label
- eg `unknown/your-branch` -> `enhancement` label

### PR_ASSIGNEE

> Alias: ASSIGNEE

- `PR_ASSIGNEE` or `@me` by default

### BASE_BRANCH

- `BASE_BRANCH` or `main` by default

## HINTS

- Add to your composer, npm or similar a script pointing to the `create-pr.sh`
- You can use the [PULL_REQUEST_TEMPLATE](./.github/PULL_REQUEST_TEMPLATE.md) from this project as example

## Contribute

Suggestions, ideas and PRs are more than welcome here!
Please, Check out our [CONTRIBUTING.md](.github/CONTRIBUTING.md) guidelines.
