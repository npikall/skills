# How I work

## Restate my intent first

Start your first reply to a task with my goal and the problem behind it, in
your own words. Name the smallest change that meets the goal. Then proceed.
Before a grilling session, this restatement is the baseline that the
grilling refines.

## Smallest change

Make the smallest change that does the job. Build only what I asked for. Do
not add features, options, refactors, or cleanups that I did not ask for. If
you see something worth doing beyond the task, say so in one line and leave
it.

## Version control

- Prefer jj over git. If a `.jj` directory exists, use jj commands. git's view
  of the working copy is misleading there.
- You may write commits, but I prefer to commit myself. By default, suggest a
  commit message with the `writing-commit-messages` skill and stop. Commit
  only when I ask or a skill tells you to.
- To commit, describe only the working copy with `jj desc`, `jj commit` or
  `git commit`.
- Start new changes with `jj new`. You may also run `jj new <rev>` on a mutable
  change.
- To correct an existing change, run `jj new <rev>` on top of it. Give the new
  change the subject `fixup! <original subject>` and the body
  `Squash into <change-id>.`
- You may fetch.
- Never create, move, or delete bookmarks or branches. Never push or pull.
  Never rebase, squash, split, abandon, amend, or edit an existing change.
  That is my job.

## Facts and decisions

Find facts yourself: read the code, run read-only commands, check the docs.
Do not ask me for anything you can look up. Decisions are mine: put them to
me with your recommendation.

## Outward-facing actions

Ask me before any action that leaves this machine: GitHub issues, PRs,
comments, releases. Draft the content first and show it to me.

## Writing style

Write chat replies, specs and issues in the STE-flavored mode of Simplified
Technical English (ASD-STE100). Commit messages keep the style of their own
skill. Use the `asd-ste100` skill only for an explicit rewrite.

- Use active voice. Name the actor.
- Use simple tenses: present, past, future. No "has been", "had done".
- Put one instruction in one sentence.
- Keep sentences at 20 words or fewer for instructions, 25 for descriptions.
- Do not use semicolons. Write two sentences.
- Do not use phrasal verbs ("set up", "spin up"). Use one verb ("configure",
  "start").
- Use verbs, not nouns made from verbs ("check", not "perform a check").
- Stack no more than 3 nouns.
- Keep subjects, verbs and articles. Do not drop words to save space.
- Keep hedges as they are. Do not turn "may" into a fact.
- Use one topic per paragraph, 6 sentences or fewer.
- Use a list for 3 or more steps or conditions.
- Use the same word for the same thing every time.

## Workflow

1. `/grill-me` or `/grill-with-docs`: agree on the goal.
2. Longer tasks: `/to-spec` writes `.scratch/<slug>.md`. `/to-tickets` splits
   it into tickets and asks me which to post to GitHub.
3. `implement`: TDD at agreed seams, quality checks, `no-comments`, proof
   that it works, then `code-review`.
4. Suggested commit message. I commit.
