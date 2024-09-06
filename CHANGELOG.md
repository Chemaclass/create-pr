# Changelog

## Unreleased

- Fix get_ticket_number when branch name contains numbers
- Load `.env.local` on top of `.env` in case it exists
- Add `{{BACKGROUND}}` with "Details in the ticket" by default when a ticket link is used
- Enable spaces inside placeholders
  - `{{ BACKGROUND }}`
- Enable placeholders inside HTML comments in the PR template
  - `<!-- {{ BACKGROUND }} -->`
- Add `LABEL_MAPPING`
  - eg `LABEL_MAPPING="feat:enhancement; fix|bug:bug; default:extra"`

## 0.2 - 2024-08-28

- Improved format_title
  - Ignore ticket key on PR title when it's not present on the branch
- Display Nope on the {{TICKET_LINK}} inside the PR template if no valid link can be created

## 0.1 - 2024-08-27

Initial release. Check README for instructions about installation and how to use it.
