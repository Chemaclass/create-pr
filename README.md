# bash-create-pr

A bash script that helps create your PRs.
It normalised the PR title, description, assignee by default and initial label based on your branch name.

## How to use it?

You need this env var `LINK_PREFIX` needed to add automatically a link to the external ticket based on the ticket-number.
```env
LINK_PREFIX=https://your-company.atlassian.net/browse/TICKET-
```

> HINT: add to your composer, npm or whatever system do you use a script pointing to the pr.sh script. 

---

## Feature example

```
feat/TICKET-01-add-new-feature
```

- prefix: feat | feature
- ticket-key: TICKET
- ticket-number: 01

#### Results

- PR title: TICKET-01 Add new feature
- Adds bug label

## Bug example

```
fix/TICKET-23-broken-something-after-xyz
```

- prefix: fix | bug | bugfix
- ticket-key: TICKET
- ticket-number: 23

#### Results

- PR title: TICKET-23 Fix broken something after xyz
- Adds bug label

> It adds 'Fix' to the title

## Others

```
docs/TICKET-45-documenting-that-thing
```

```
refactor/TICKET-67-documenting-that-thing
```