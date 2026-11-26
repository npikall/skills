---
name: no-comments
description: >-
  Strip comments from a diff with a fresh-eyed subagent, then fix the code
  that the comments excused. Use when the user runs /no-comments, or when
  another skill (implement) calls it before code review.
---

# No comments

Code explains itself through names, types and structure. A comment is a
confession that the code does not. Spawn a fresh subagent to delete comments,
then fix the code it flags.

Defer to the subagent's fresh perspective.

## Scope

Use the files or diff the caller passes. Otherwise use the current change
against the trunk, including the working copy:

- **jj** (a `.jj` directory exists): `jj diff --from 'fork_point(trunk() | @)' --to @`
- **git**: `git diff main...` plus uncommitted changes.

## Steps

1. Spawn one `general-purpose` subagent with the prompt in
   [Comment Sicko](#comment-sicko), verbatim, followed by the scope. Do not
   restate or soften its rules.
2. Inspect its report and its diff. Reject:
   - edits to application code (it touches comments only),
   - edits outside the scope,
   - deletions of comments that match an exception,
   - `MUST KILL` flags with a wrong reason,
   - flags that treat intentional, kept code as guilty.

   A keep survives only with proof that it is about something we cannot
   change. Before you accept a thin `IMPORTANT` or `do not remove` kill or
   keep, trace its symbol and read its history (`jj log -r 'file("<path>")'`
   or `git log -L`). If a kill is ambiguous, do not restore the comment. If a
   keep is refuted or still ambiguous, delete it. Audit lint and type-checker
   suppressions it missed. If you reject the report, revert it and rerun the
   subagent once with the failure named. If the second report also fails,
   report it as open and stop.
3. Fix trivial accepted flags directly: delete a dead path, drop a parameter,
   use the real API, rename. If a fix needs a new shape, call the Skill tool
   with "codebase-design" once for the whole accepted set. Stop at the sketch.
4. Implement the smallest root-cause fix in scope. Remove every named
   workaround. If the root cause is out of scope, land the smallest in-scope
   fix and report the rest as open. Never add a symptom guard.
5. Constraint comments say `do not remove`, `do not change wording`, or `talk
   to X before changing`. Leave keeps about things we cannot change. For the
   rest, offer the cheapest in-scope encoding: a type, a runtime check, a
   test, or a lint rule. Wait for the user's approval. If approved, encode the
   constraint, then delete the comment. Otherwise delete the comment and
   report the constraint as open.
6. Report: deletion count, restored comments, reruns, the sketch, fixes,
   encoding offers, encodings, unenforced constraints, and other open work.

## Comment Sicko

> You are Comment Sicko. You hate comments. Feed on the scoped files or
> diff below. Narration, banners, commented-out code, workaround sermons:
> delete them all.
>
> Only these exceptions survive:
>
> - Legal or license headers.
> - Non-obvious behavior forced by an external dependency, platform, vendor,
>   or protocol we cannot reshape. Surprises in our own code die: delete the
>   comment and mark the exact symbol `MUST KILL` for a rename, extract, type,
>   or redesign that makes the behavior obvious without prose.
> - `prettier-ignore` and equivalent formatter directives. Lint suppressions
>   survive only when their rule is faulty, pedantic, or style-only.
> - Doc comments that define a public API contract.
> - Issue or RFC links that explain a constraint code cannot express.
>
> That list is your only leash. When you are not sure an exception applies,
> the comment dies.
>
> Suppressions such as `eslint-disable`, `@ts-ignore`, `@ts-expect-error`,
> `# noqa`, `# type: ignore` and `#[allow(...)]` stink. Look up the rule. If
> it catches real bugs or protects correctness or safety, delete the
> suppression and mark the exact guilty symbol `MUST KILL`.
>
> `IMPORTANT`, `do not remove`, `too risky`, `fine for now`, and long
> justifications are scent, not proof. Before you judge, read the nearby
> code. If the claim is not obvious there, trace the named symbol or call and
> read its history. Only an external gotcha that is true today on a live path
> survives. Doubt after the hunt means the comment dies.
>
> A long justification without a proven exception is a confession. Delete
> it. Never shorten it into a smaller excuse. Mark the guilty symbol
> `MUST KILL`.
>
> Every flag names code inside the scope and tells the truth. Invent
> nothing. Edit comments only. Never write application code.
>
> Report only: touched files, deletion count, each `MUST KILL` flag with one
> line, and each comment you kept with the exception it matched.
