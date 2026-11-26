# Skills

My personal Claude Code skills. The skills in `skills/` are adapted from the
upstream sources below. This repo owns them: there is no automatic sync with
upstream.

## How the skills work together

The skills form one pipeline from an idea to a pull request. Each stage writes an
artifact that the next stage reads. The agent never commits. I commit myself.

```
idea
  │
  ▼
/grill-me ─────────── or ─────────── /grill-with-docs
  │ (grilling)                         │ (grilling + domain-modeling)
  │                                    │  writes CONTEXT.md, docs/adr/
  ▼                                    ▼
shared understanding of the goal
  │
  ├── short task ──────────────────────────────┐
  │                                            │
  ▼  longer task                               │
/to-spec    → .scratch/<slug>.md               │
  │                                            │
  ▼                                            │
/to-tickets → .scratch/<slug>/issues/NN-*.md   │
  │           (optional: GitHub issues)        │
  ▼                                            ▼
/implement  (TDD at agreed seams, codebase-design when needed)
  │
  ▼
no-comments → full suite, mutator → proof that it works
  │
  ▼
code-review (Standards axis + Spec axis)
  │
  ▼
writing-commit-messages → I commit
  │
  ▼
I push → /open-pr → PR on GitHub (after my approval)
```

The skills fall into three groups:

- **Entry points.** I start these with a slash command. The model does not
  start them by itself: `grill-me`, `grill-with-docs`, `to-spec`,
  `to-tickets`, `handoff`, `create-verification-skill`, `open-pr`.
- **Building blocks.** Other skills call these with the Skill tool. The model
  can also start them when a task fits: `grilling`, `domain-modeling`,
  `codebase-design`, `implement`, `no-comments`, `code-review`,
  `writing-commit-messages`.
- **Standalone tools.** These are not part of the pipeline: `asd-ste100`,
  `flat-svg-logo`.

### Shared artifacts

The skills do not pass state to each other directly. They read and write files
in the project:

| Artifact                        | Written by        | Read by                                  |
| ------------------------------- | ----------------- | ---------------------------------------- |
| `CONTEXT.md` (domain glossary)  | `domain-modeling` | `to-spec`, `to-tickets`, `implement`     |
| `docs/adr/*.md` (decisions)     | `domain-modeling` | `to-spec`, `to-tickets`, `implement`     |
| `.scratch/<slug>.md` (spec)     | `to-spec`         | `to-tickets`, `implement`, `code-review` |
| `.scratch/<slug>/issues/*.md`   | `to-tickets`      | `implement`, `code-review`               |
| `.metrics/`                     | `implement`       | `implement`                              |
| handoff document in `$TMPDIR`   | `handoff`         | the next agent session                   |

`.scratch/` and `.metrics/` are local working files. The skills add them to
`.gitignore`, and they are never committed.

### Shared rules

All skills follow the same rules from `CLAUDE.md`:

- The agent makes the smallest change that does the job.
- The agent finds facts itself. Decisions are mine.
- The agent asks before any action that leaves the machine, for example a
  GitHub issue.
- The agent uses jj in a repo with a `.jj` directory.
- The agent never changes history. It suggests a commit message and stops.

## A typical workflow

### Short task

1. Run `/grill-me` to agree on the goal. The agent asks questions in rounds
   and gives a recommended answer for each. Use `/grill-with-docs` when the
   task touches domain terms. That variant also updates `CONTEXT.md` and
   offers ADRs.
2. Confirm that the agent and I have a shared understanding.
3. Run `/implement`. The agent proposes the seams to test at. I confirm them.
4. The agent works in red-green slices. After each slice it runs `crapper`
   and `dryer` on the touched code.
5. At the end, the agent runs `no-comments`, the full suite and `mutator`.
   It proves that the change works on the real artifact. Then it calls
   `code-review`.
6. The agent reports what it did and what it skipped. Then it suggests a
   commit message.
7. I review the change and commit it.

### Longer task

1. Run `/grill-me` or `/grill-with-docs` as above.
2. Run `/to-spec`. The agent confirms the test seams with me and writes
   `.scratch/<slug>.md`.
3. Run `/to-tickets`. The agent proposes vertical slices with blocking
   edges. I approve the breakdown.
4. The agent writes one file per ticket under `.scratch/<slug>/issues/`. It
   asks me, ticket by ticket, whether to post it to GitHub.
5. For each ticket whose blockers are done, run `/implement` with the ticket
   path. Each ticket ends with a review and a suggested commit message.
6. I commit after each ticket.

When a session gets long, run `/handoff` with a short note about the next
step. Start a fresh session and point it at the handoff document.

## Installation

The `justfile` links the skills and `CLAUDE.md` into `~/.claude`:

| Command               | Effect                                                 |
| --------------------- | ------------------------------------------------------ |
| `just status`         | List installed and tracked skills with their state.    |
| `just install`        | Symlink the tracked skills and `CLAUDE.md`.            |
| `just uninstall NAME` | Remove the symlink of a skill if it points to this repo. |
| `just import NAME`    | Copy an installed skill into `skills/` and link it back. |

`CLAUDE.md` is my global instruction file, installed as `~/.claude/CLAUDE.md`.

## Sources

| Skill                     | Upstream                    | Path in upstream                               | Folder hash at import                      |
| ------------------------- | --------------------------- | ---------------------------------------------- | ------------------------------------------ |
| `grill-me`                | `mattpocock/skills`         | `skills/productivity/grill-me`                 | `3df14e2d3a89459bf300614be9247e3ce74798f8` |
| `grilling`                | `mattpocock/skills`         | `skills/productivity/grilling`                 | `f0732035b8b1b60ae39454e4191caef32fa91903` |
| `grill-with-docs`         | `mattpocock/skills`         | `skills/engineering/grill-with-docs`           | `eedaf2562c83155115e9c649fa3ecaac2e10e81d` |
| `domain-modeling`         | `mattpocock/skills`         | `skills/engineering/domain-modeling`           | `388c9822641805ca2dcd5038e68a1d5282437ee5` |
| `codebase-design`         | `mattpocock/skills`         | `skills/engineering/codebase-design`           | `344e3efc88ee60663b2e989555c2efdb548fbd42` |
| `code-review`             | `mattpocock/skills`         | `skills/engineering/code-review`               | `d8e341cee7980127dddda05159bedf25dc853615` |
| `to-spec`                 | `mattpocock/skills`         | `skills/engineering/to-spec`                   | `136b9651747cfccbfbb7c50a6b0dfb757e7547d2` |
| `to-tickets`              | `mattpocock/skills`         | `skills/engineering/to-tickets`                | `b32c94e5a51c24ee9c41fcb7fe9ea9fff9af6369` |
| `implement`               | `mattpocock/skills`         | `skills/engineering/implement`                 | `f07d230f645fc9ac390cf13a450bbff12ad791a3` |
| `tdd`                     | `mattpocock/skills`         | `skills/engineering/tdd`                       | `79288be15c67b849f22b6572056601090fd20913` |
| `ub-mode`                 | `unclebob/ub-mode`          | `.`                                            | `3da62bf3fcfd2034de41f30d920d2739e566171f` |
| `ponytail`                | `dietrichgebert/ponytail`   | `skills/ponytail`                              | `cb6e53477eaf04e6daeca22feacb85f9ce20d40c` |
| `asd-ste100`              | `danyuchn/asd-ste100-skill` | `.`                                            | `707362731928d0d92526c066df15dbbe6a378c07` |
| `no-comments`             | `cursor/plugins`            | `pstack/skills/no-comments`                    | `6708dc37f8e2695b0063a60e06dcdc451eed5355` |
| `create-verification-skill` | `cursor/plugins`          | `pstack/skills/create-verification-skill`      | `5aa2dae2726d09d219397fbbedc1e9500a239d28` |
| `flat-svg-logo`           | local                       |                                                |                                            |
| `writing-commit-messages` | own                         |                                                |                                            |
| `open-pr`                 | own                         |                                                |                                            |

`implement` merges the upstream `implement`, `tdd`, `ub-mode` and `ponytail`
skills. The `ub-mode` license (MIT) is kept as
`skills/implement/LICENSE-ub-mode`. `ponytail` declares `license: MIT` in its
frontmatter but shipped no LICENSE file.

`no-comments` puts the `pstack/agents/comment-sicko.md` agent
(`14c2402f3d8c81b39d75747d6eb892f343e6a903`) inline as its subagent prompt.
`implement` takes its "prove it works" step from
`pstack/skills/principle-prove-it-works`
(`71f6ab944f3fc9d5bb9b1b261edfa80ded54b96c`). The pstack license (MIT) is kept
as `LICENSE-pstack` in both imported skills.

Upstream repos are on GitHub (`https://github.com/<upstream>`). Folder hashes
come from `~/.agents/.skill-lock.json` (the `skills` CLI lockfile). Hashes of
the pstack skills come from the GitHub contents API.
