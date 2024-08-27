# create-pr.sh

A bash script that helps create your PRs.
It normalised the PR title, description, assignee by default and initial label based on your branch name.

> It requires https://cli.github.com/

## Installation

Download the latest `single executable script` on the [Releases page](https://github.com/Chemaclass/bash-create-pr/releases), or build it yourself. You can validate the file's checksum to validate that it wasn't altered. The checksum for each release is on each release on GitHub.

To build the project yourself, you can do it manually or execute it `./build.sh`.

## How to use it?

Optional env vars:
- `PR_TICKET_LINK_PREFIX=https://your-company.atlassian.net/browse/` 
  - This will be replaced in the placeholder `{{TICKET_LINK}}` in your PR template 
  - If no value is present for `PR_TICKET_LINK_PREFIX` then the `{{TICKET_LINK}}` will be ignored
  - It will use the ticket key and number to append to the link prefix
- `PR_TEMPLATE_DIR=.github/PULL_REQUEST_TEMPLATE.md`
- `LABEL=enhancement` or extracted from the branch's prefix
- `BASE_BRANCH=main` or extracted from the branch's prefix
- `ASSIGNEE=@me` or extracted from the branch's prefix

### HINTS

- Add to your composer, npm or similar a script pointing to the `create-pr.sh`
- You can use the [PULL_REQUEST_TEMPLATE](./.github/PULL_REQUEST_TEMPLATE.md) from this project as example

---

## Development

- Entry point `create-pr.sh`
- Isolated testable functions inside files under the `src` directory
- There is a build script that will generate 1-single-executable script combining all files from src and the entry point.

### Tests

Tests written in [bashunit](https://bashunit.typeddevs.com/)

```bash
lib/bashunit tests
```

---

## Examples

For the full experience, make sure to have a `PULL_REQUEST_TEMPLATE` in your project.

### Feature example

```
feat/TICKET-01-add-new-feature
```

- prefix: `feat` | `feature`
- ticket-key: `TICKET`
- ticket-number: `01`

#### Results

- PR title: `TICKET-01 Add new feature`
- Adds `enhancement` label

### Bug example

```
fix/TICKET-23-broken-something-after-xyz
```

- prefix: `fix` | `bug` | `bugfix`
- ticket-key: `TICKET`
- ticket-number: `23`

#### Results

- PR title: `TICKET-23 Fix broken something after xyz`
- Adds `bug` label

> It adds 'Fix' to the title
