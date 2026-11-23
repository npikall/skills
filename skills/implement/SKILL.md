---
name: implement
description: >-
  Write or change code test-first with the smallest change that works. Use for
  any task that writes, changes, or fixes code (features, bug fixes,
  refactors), or when the user runs /implement with a spec or tickets.
---

# Implement

Implement the work the user describes, directly or in a spec or tickets (often
under `.scratch/`). Read `CONTEXT.md` (if it exists) so names match the domain
language, and respect ADRs in the area you touch.

The user commits and pushes. Never stage, commit, amend, push, or clean up
worktrees. The job ends with a suggested commit message.

## Smallest change

Read the task and the code it touches first. Trace the real flow end to end.
Then climb this ladder and stop at the first rung that holds:

1. **Does this need to exist at all?** Speculative need: skip it, say so in one line.
2. **Already in this codebase?** Reuse the helper, type, or pattern that lives here.
3. **Stdlib does it?** Use it.
4. **Native platform feature covers it?** Use it.
5. **Already-installed dependency solves it?** Use it. Never add a dependency for what a few lines can do.
6. **Only then:** the minimum code that works.

Rules:

- Build only what was asked. No extra features, options, or "for later"
  scaffolding.
- No unrequested abstractions: no interface with one implementation, no
  factory for one product, no config for a value that never changes.
- Subtract before you add. Deletion over addition. Boring over clever.
- Fewest files, shortest working diff. The smallest change in the wrong place
  is a second bug.
- One decision lives in one place.
- Do not bolt a new requirement onto a design that does not fit it. Ask what
  you would have built if it had been there from the start, and deliver that
  in pieces.
- Mark a deliberate simplification with a known ceiling (global lock, O(n²)
  scan) with a comment naming the ceiling and the upgrade path.

Never simplify away: input validation at trust boundaries, error handling that
prevents data loss, security measures, or anything explicitly requested.

## Design

- Get the data shape right before you write the logic.
- Make illegal states impossible to represent. Do not silence the compiler.
- Check data where it enters. Parse outside data once. Inside, trust it.
- Keep business logic in pure functions.
- Make operations idempotent: running twice, or after a crash halfway, ends in
  the same state.
- If two actors do not need the same mutable state, give each its own. If they
  do, allow one writer and enforce it in the structure.
- If code is already clear and local, leave it.

## Seams

A **seam** is the public boundary you test at. Tests live at seams, never
against internals.

Before writing any test, write down the seams under test and confirm them with
the user: "What's the public interface, and which seams should we test?" No
test is written at an unconfirmed seam. Prefer existing seams and the highest
seam possible.

When the shape of the interface is itself in question, call the Skill tool
with "codebase-design" for the vocabulary.

## The loop

Work in vertical slices: one seam, one test, one minimal implementation per
cycle. Each test is a tracer bullet that responds to what the last cycle
taught you.

1. **Red.** Write the failing test. See it fail for the reason you expect.
2. **Green.** Make the smallest change that makes it pass. Don't anticipate
   future tests.
3. **Check the slice.** Run `crapper` on the touched code. Reduce every
   function with CRAP ≥ 10 by splitting it, testing it, or both. Run `dryer`
   and remove duplication with a score of 0.8 or above. Consider whether case
   statements are worth reducing.
4. Finish and check this slice before you start the next.

Pass the touched source paths to `crapper`, `dryer` and `mutator` as
arguments. Their `--changed` flag reads `git status`, which is wrong in jj
repos.

Run typechecking and single test files often. Run the full suite once at the
end.

Refactor only on green, and only to fix a finding from step 3 or from review:
pin what the code does, change the structure, prove the behavior did not
change.

### Good tests

Tests verify behavior through public interfaces. A good test reads like a
specification and survives refactors. See [tests.md](tests.md) for examples
and [mocking.md](mocking.md) for mocking guidelines.

Anti-patterns:

- **Implementation-coupled**: mocks internal collaborators, tests private
  methods, or verifies through a side channel. It breaks on refactor when
  behavior has not changed.
- **Tautological**: the assertion recomputes the expected value the way the
  code does. Expected values come from an independent source: a known-good
  literal, a worked example, the spec.
- **Hollow**: it would still pass if every function returned nothing. Throw
  it out.
- **Horizontal slicing**: all tests first, then all implementation.

If an honest test is impractical, do not write a bad one. Say so.

## Bugs

- Reproduce it. Fix the cause. A guard that only hides the crash is not a fix.
- Before you edit, find every caller of the function you touch. One fix in the
  shared function beats a guard in every caller.
- When two fixes that share one premise fail the same check, write that
  premise in one sentence and question it before you try a third fix.

## Finish

1. Run the full test suite.
2. Run `mutator` on the changed code. Cover the uncovered, kill the
   survivors, delete dead code.
3. Call the Skill tool with "code-review" to review the work.
4. If out-of-scope work turned up (a bug elsewhere, a follow-up feature),
   draft a GitHub issue for each. Ask the user before posting any of them
   with `gh issue create`.
5. Report briefly: what you did and why, what you skipped and when to add it.
6. Call the Skill tool with "writing-commit-messages" to suggest a commit
   message. Stop.
