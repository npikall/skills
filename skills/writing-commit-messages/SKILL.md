---
name: writing-commit-messages
description: >-
  Suggests a Conventional Commits message for the current changes,
  without committing anything. Use whenever the user asks to write,
  draft, suggest, or improve a commit message, asks "what should I
  commit this as", or wants to describe their staged or uncommitted
  changes for a commit — even if they say "commit this" (suggest the
  message; the user commits themselves).
---

# Writing Commit Messages

Suggest a commit message for the user's changes. The user runs every
state-changing git/jj command themselves; your job ends at handing
them a message they can paste.

## Hands off the repository

Only run read-only commands to inspect changes. Never stage, commit,
amend, stash, reset, checkout, restore, rebase, push, or otherwise
change repository or working-tree state, and don't edit files. This
holds even if the user says "commit this": suggest the message and
let them run the commit. The user wants full control over what goes
into history, and an unexpected commit is annoying to undo.

Allowed (git): `git status`, `git diff`, `git diff --staged`,
`git log`, `git show`, `git branch --show-current`.
Allowed (jj, if a `.jj` directory exists): `jj status`, `jj diff`,
`jj log`, `jj show`. Prefer jj over git in jj repos, since git's view
of the working copy can be misleading there.

## Workflow

1. Check status. In git, if anything is staged, base the message on
   `git diff --staged` only — that is what will be committed. If
   nothing is staged, use `git diff` (and note untracked files from
   status) and say the message assumes all changes get staged.
2. Read `git log --oneline -15` to pick up the scopes and wording the
   project already uses, so the message fits in.
3. Look for references: issue/PR numbers in the branch name, diff,
   or what the user told you.
4. If the changes are clearly unrelated (e.g. a feature plus an
   unrelated CI fix), say so and suggest how to split them, with a
   message per group and which files belong to each. Let the user
   decide.
5. Draft the message and present it in a fenced code block so it
   copies cleanly. Add at most a line or two outside the block if
   something needs flagging (assumptions, a possible split, an
   alternative type). No commit command needed unless asked.

## Format

Follow [Conventional Commits](https://www.conventionalcommits.org):

```
<type>(<scope>): <summary>

<body>

<footers>
```

### Subject line

- **type**: `feat` (new user-facing capability), `fix` (bug fix),
  `refactor` (no behavior change), `perf`, `test`, `docs`, `build`,
  `ci`, `chore`, `style`, `revert`. Pick by the change's main
  intent; a fix that also adds a test is still `fix`.
- **scope**: short, lowercase area of code, derived from file paths
  (package, module, or directory), e.g. `lexer`, `eval`, `format`.
  Reuse scopes from the log when they fit. Omit the scope (and
  parens) when the change is genuinely cross-cutting rather than
  inventing a vague one.
- **summary**: lowercase start, imperative mood ("add", not
  "added"/"adds"), no trailing period. Aim for ≤ 60 characters for
  the whole subject line, hard limit 72.
- **breaking changes**: add `!` before the colon
  (`feat(edit)!: ...`) and a `BREAKING CHANGE:` footer explaining
  what users must change.

### Body

Skip the body when the subject says it all (typo fixes, trivial
chores). Otherwise:

- Keep it short: one to three sentences, usually two to four
  wrapped lines. State the high-level concept of what changed and
  why. Someone skimming `git log` should get the idea at a glance.
  The diff carries the details, so a body that restates it buries
  the point.
- Stay at the level of the idea, not the inventory. Don't list
  individual files, functions, test cases, or every sub-change. If
  you're tempted to enumerate, name the common thread instead
  (e.g. "add boundary tests for the range checks" rather than
  naming each boundary).
- Plain prose, not bullet lists, wrapped at ~72 characters.
- Direct and technical, no filler ("This commit...", "In order
  to...").

### Footers

- References go here, one per line: `Closes #123` when the commit
  resolves an issue, `Refs: #123` when it's only related.
- `BREAKING CHANGE: <description>` for breaking changes.
- Omit the footer section entirely when there's nothing to put in it.

## Example

```
fix(lexer): handle escaped quotes in multi-line basic strings

An escaped quote right before `"""` ended the string early. Consume
escapes before checking for the closing delimiter.

Closes #42
```
