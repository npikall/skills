---
name: open-pr
description: Open a GitHub pull request for the pushed branch, with a short why, how and proof, and text-native visuals. Posts only after the user approves the draft.
disable-model-invocation: true
---

# Open PR

Open a pull request that a reviewer understands at a glance: why the change
exists, how it works, and what proves it. The user pushes. You draft, the user
approves, then you post with `gh`.

Until the user approves, change nothing outside `.scratch/` and `.gitignore`.

## 1. Check the branch

Find the branch. In a git repo, it is the current branch. In a repo with a
`.jj` directory, use jj, and the branch is the bookmark from
`jj log -r 'heads(::@ & bookmarks())' --no-graph -T bookmarks`.

In a jj repo without a `.git` directory, `gh` cannot find the repo. Pass
`--repo <owner>/<name>` to every `gh` command, with the values from
`jj git remote list`. `gh repo view` takes `<owner>/<name>` as an argument
instead.

Each of these conditions stops the skill. Tell the user which one holds:

- The branch tip and its remote tip differ, or the remote has no such branch.
  Ask the user to push or sync it.
- The conversation shows no proof that the change works. Ask the user to
  prove it first, for example with `/implement`.

The base is the repo default from `gh repo view --json defaultBranchRef`,
unless the user names another base.

Find an open PR with `gh pr list --head <branch> --state open --json number,url`.
If one exists, this run offers to update that PR instead of creating a new one.

## 2. Gather the material

- The commits and the diff between the base and the branch.
- The why: the conversation, a spec under `.scratch/`, or an issue. Find the
  issue number in the branch name, the commits or the conversation.
- The proof: the check that the conversation used to prove the change. Note
  the commit it ran on. If the branch tip is a different commit, the draft
  shows a warning: `Proof ran on <old>, the branch tip is <new>.`
- A pull request template in `.github/`, `docs/` or the repo root. If one
  exists, fill it in place of the template below.

## 3. Draft

Write the title in Conventional Commits form, with the type and scope rules
from the `writing-commit-messages` skill.

Write the body in the style of the "Writing style" section of
`~/.claude/CLAUDE.md`. The body fits on one screen: about 250 words, not
counting the visuals.

```markdown
<one-line summary>

## Why

<the problem, 2-4 sentences>

Closes #<n>

## How

- <the approach, one bullet per idea>

<visual, if one earns its place>

## Proof

<one line that names the check, for example "Tested with `scripts/check.sh`"
or "Checked in the browser at `/settings`">

## How to review

<where to start reading, and what deserves the hardest look>
```

Omit `Closes #<n>` when no issue exists.

### Visuals

Use text-native visuals only. GitHub renders them, and they need no upload.
Use at most two. Pick by what the change alters:

| The change alters                             | Visual                         |
| --------------------------------------------- | ------------------------------ |
| control flow, data flow, module structure     | a `mermaid` code block         |
| observable behavior: output, errors, defaults | a before/after table           |
| CLI or TUI output that a table cannot hold    | before and after code blocks   |

When the text alone is clear, the PR has no visual.

## 4. Approve and post

The draft file is `.scratch/pr-<slug>.md`, where `<slug>` is the branch name
with `/` replaced by `-`.

1. Write the body to the draft file. Add `.scratch/` to `.gitignore` if it is
   not there.
2. Show the user the title, the body and any proof warning. Wait for approval
   or changes.
3. After the user approves, post:
   - New PR: `gh pr create --base <base> --head <branch> --title "<title>" --body-file .scratch/pr-<slug>.md`
   - Open PR: `gh pr edit <number> --title "<title>" --body-file .scratch/pr-<slug>.md`
4. Show the PR URL. Stop.

Set no labels, reviewers or assignees. Add `--draft` only when the user asks
for a draft PR.
