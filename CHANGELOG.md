# Changelog

## [0.9.0](https://github.com/Chemaclass/create-pr/compare/0.8...0.9.0) - 2025-07-25

- Fix validate target branch
- Trim unicode from pr title

## [0.8.0](https://github.com/Chemaclass/create-pr/compare/0.7...0.8) - 2024-10-28

- Use ticket number only at the beginning of branch name
- Add `PR_TITLE_REMOVE_PREFIX`: Remove custom prefix text from the generated title
- Add `PR_REVIEWER`: Allow adding reviewers via local .env

## [0.7](https://github.com/Chemaclass/create-pr/compare/0.6...0.7) - 2024-09-29

- Validate current branch is not target branch
- Internal refactorings and minor improvements

## [0.6](https://github.com/Chemaclass/create-pr/compare/0.5...0.6) - 2024-09-16

- Fix additional single quotes on `PR_TITLE_TEMPLATE`
- Improve feedback when given wrong PR template
- Add GitLab support
- Add `--dry-run` to display the used data before creating the PR
- Rename build executable script to `create-pr`
- Allow passing extra arguments to the `gh` or `glab` tools

## [0.5](https://github.com/Chemaclass/create-pr/compare/0.4...0.5) - 2024-09-09

- Support ticket link with number
- Remove ticket number from PR title when there is no ticket key
- Add `PR_LINK_PREFIX_TEXT`
  - Text to display if the link does not contain a `TICKET_KEY`
- Add `PR_TITLE_TEMPLATE`
  - Enable custom PR title with placeholders (`{{TICKET_NUMBER}}`, `{{TICKET_KEY}}`, `{{PR_TITLE}}`)
  - eg `PR_TITLE_TEMPLATE="{{TICKET_KEY}}-{{TICKET_NUMBER}} {{PR_TITLE}}"`
- Refactor unique src file into multiple (single scope/responsibility) files
- Add option `-t|--title` to generate a branch name based on the PR title.
- Replace `PR_TEMPLATE_DIR` to `PR_TEMPLATE_PATH`

## [0.4](https://github.com/Chemaclass/create-pr/compare/0.3...0.4) - 2024-09-06

- Fix pr_ticket_number when branch name contains numbers
- Load `.env.local` on top of `.env` in case it exists
- Add `{{BACKGROUND}}` with "Details in the ticket" by default when a ticket link is used
- Enable spaces inside placeholders
  - `{{ BACKGROUND }}`
- Enable placeholders inside HTML comments in the PR template
  - `<!-- {{ BACKGROUND }} -->`
- Add `PR_LABEL_MAPPING`
  - eg `PR_LABEL_MAPPING="feat:enhancement; fix|bug:bug; default:extra"`

## [0.3](https://github.com/Chemaclass/create-pr/compare/0.2...0.3) - 2024-09-05

- Fix format PR body with number in branch name
- Fix ticket key without numbers but branch prefix

## [0.2](https://github.com/Chemaclass/create-pr/compare/0.1...0.2) - 2024-08-28

- Improved format_title
  - Ignore ticket key on PR title when it's not present on the branch
- Display Nope on the {{TICKET_LINK}} inside the PR template if no valid link can be created

## [0.1](https://github.com/Chemaclass/create-pr/compare/main...0.1) - 2024-08-27

Initial release. Check README for instructions about installation and how to use it.
