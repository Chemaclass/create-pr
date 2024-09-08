# Changelog

## Unreleased

- Support ticket link with number
- Remove ticket number from PR title when there is no ticket key
- Add `PR_TICKET_PREFIX_TEXT`

## 0.4 - 2024-09-06

- Fix get_ticket_number when branch name contains numbers
- Load `.env.local` on top of `.env` in case it exists
- Add `{{BACKGROUND}}` with "Details in the ticket" by default when a ticket link is used
- Enable spaces inside placeholders
  - `{{ BACKGROUND }}`
- Enable placeholders inside HTML comments in the PR template
  - `<!-- {{ BACKGROUND }} -->`
- Add `PR_LABEL_MAPPING`
  - eg `PR_LABEL_MAPPING="feat:enhancement; fix|bug:bug; default:extra"`

## 0.3 - 2024-09-06

- Fix format PR body with number in branch name
- Fix ticket key without numbers but branch prefix

## 0.2 - 2024-08-28

- Improved format_title
  - Ignore ticket key on PR title when it's not present on the branch
- Display Nope on the {{TICKET_LINK}} inside the PR template if no valid link can be created

## 0.1 - 2024-08-27

Initial release. Check README for instructions about installation and how to use it.
