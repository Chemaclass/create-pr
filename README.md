# create-pr

A bash script that helps create your PRs.
It normalizes the PR title, description, assignee by default, and initial label based on your branch name.

## Current support

- **GitHub** requires https://cli.github.com/manual/gh_pr_create
- **GitLab** requires https://gitlab.com/gitlab-org/cli/-/blob/main/docs/source/mr/create.md

> These are needed to access your client via the terminal, and they are independent of this script.

### Extra arguments

Any additional argument will be passed to `gh` or `glab` tool.

```bash
# Create a draft PR
./create-pr --draft

# Create a draft PR with an overridden title
./create-pr --draft --title="Custom Title"
```

* GitHub: https://cli.github.com/manual/gh_pr_create
* GitLab: https://gitlab.com/gitlab-org/cli/-/blob/main/docs/source/mr/create.md

## Installation

You can download the latest `single executable script` on the [Releases page](https://github.com/Chemaclass/bash-create-pr/releases) or build it yourself.

If you download the executable file from a release's GitHub project, you can check the file's checksum to validate that
it was not altered. The checksum for each release is on each release on GitHub.

To build the project yourself, execute the script `./build.sh` and move the resulting `bin/create-pr` script wherever you want.

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
PR_TICKET_LINK_PREFIX="https://github.com/Chemaclass/create-pr/issues/"
PR_LINK_PREFIX_TEXT="Closes: "
```

- Result: `Closes: https://github.com/Chemaclass/create-pr/issues/27`

### PR_TITLE_TEMPLATE

Enable custom PR title with placeholders:

- `{{TICKET_NUMBER}}`
- `{{TICKET_KEY}}`
- `{{PR_TITLE}}`

#### Example

```bash
PR_TITLE_TEMPLATE="{{TICKET_KEY}}-{{TICKET_NUMBER}} {{PR_TITLE}}"
```

### PR_TITLE_REMOVE_PREFIX

Remove custom prefix text from the generated title.
Useful when you have tickets prefixed with some text like `BE:` or `FE:`.

#### Example

By default, having a branch named: `feat/ticket-123-be-crete-feature-foo`

Default behaviour:
- `TICKET-123 Be create feature foo`

With `PR_TITLE_REMOVE_PREFIX=be` the result will be:
- `TICKET-123 Create feature foo`

> This variable accept multiple strings to consider/remove comma separated.
>
> Eg: `PR_TITLE_REMOVE_PREFIX=be,fe`

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
PR_LABEL_MAPPING="docs:documentation; fix|bug|bugfix|hotfix:bug; default:enhancement"
```

- eg `docs/your-branch` -> `documentation` label
- eg `fix/your-branch` -> `bug` label
- eg `bug/your-branch` -> `bug` label
- eg `unknown/your-branch` -> `enhancement` label

### PR_ASSIGNEE

> Alias: ASSIGNEE

- `PR_ASSIGNEE` or `@me` by default

### PR_REVIEWER

> Alias: REVIEWER

- Empty by default

### TARGET_BRANCH

- `TARGET_BRANCH` or `main` by default

## HINTS

- Add to your composer, npm or similar a script pointing to the `create-pr`
- You can use the [PULL_REQUEST_TEMPLATE](./.github/PULL_REQUEST_TEMPLATE.md) from this project as example

## Contribute

Suggestions, ideas and PRs are more than welcome here!
Please, Check out our [CONTRIBUTING.md](.github/CONTRIBUTING.md) guidelines.
