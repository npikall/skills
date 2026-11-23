# Skills

This repo is my personal skills repository. It holds the skills I use on a
regular basis, adapted to the way I work. The repo owns these skills: there is
no automatic sync with upstream. I may pull upstream changes in by hand later.

## Working principles

- The agent makes the smallest change that does the job. No extra features
  unless I ask for them.
- I commit and push myself. The agent suggests a commit message
  (`writing-commit-messages`) and stops.
- The agent looks up facts itself. Decisions are mine.
- The agent asks before any outward-facing action (GitHub issues, PRs).
- jj over git: in a repo with `.jj`, the agent uses jj commands.
- Replies come back in Simplified Technical English (STE100).

## Desired workflows

Feature in a brown-field repo:

1. `/grill-me` or `/grill-with-docs`: narrow the goal down from the domain level
   to lower levels where relevant.
2. `/implement`: TDD loop, CRAP and duplication checks, mutation testing.
3. `code-review`.
4. Suggested commit message. I commit.

Longer task: same as above, plus:

- `/to-spec` writes `.scratch/<slug>.md` (never committed).
- `/to-tickets` splits the spec into `.scratch/<slug>/issues/` and asks me,
  ticket by ticket, whether to post it to GitHub.

## Tracked skills

| Skill                     | Upstream                    |
| ------------------------- | --------------------------- |
| `grill-me`                | `mattpocock/skills`         |
| `grilling`                | `mattpocock/skills`         |
| `grill-with-docs`         | `mattpocock/skills`         |
| `domain-modeling`         | `mattpocock/skills`         |
| `codebase-design`         | `mattpocock/skills`         |
| `code-review`             | `mattpocock/skills`         |
| `to-spec`                 | `mattpocock/skills`         |
| `to-tickets`              | `mattpocock/skills`         |
| `implement`               | `mattpocock/skills`         |
| `tdd`                     | `mattpocock/skills`         |
| `ub-mode`                 | `unclebob/ub-mode`          |
| `ponytail`                | `dietrichgebert/ponytail`   |
| `asd-ste100`              | `danyuchn/asd-ste100-skill` |
| `flat-svg-logo`           | (local)                     |
| `writing-commit-messages` | own                         |

`implement`, `tdd`, `ub-mode` and `ponytail` are merged in phase 2 (see below).
The README gets this table plus the upstream commit hash of each skill, taken
from `~/.agents/.skill-lock.json`.

## Phase 1: copy as-is

- Copy each tracked skill from `~/.agents/skills/<name>/` (or
  `~/.claude/skills/<name>/`) to `skills/<name>/`.
- Exclude `agents/openai.yaml`, `.claude-plugin/` and `README.md`. Keep LICENSE
  files (MIT attribution) and every file a SKILL.md references.
- Write the README with the source table.
- I commit.

## Phase 2: adapt

### Merged `implement` skill

- Merge `implement` + `tdd` + `ub-mode` + the change-minimizing parts of
  `ponytail` into one `implement` skill. Delete `tdd`, `ub-mode` and `ponytail`
  afterwards. Keep `tdd`'s `tests.md` and `mocking.md` as references of
  `implement`.
- Claude may load it on its own (no `disable-model-invocation`).
- Keep the seam checkpoint: agree test seams with me before writing tests.
- Loop: red → green per slice → `crapper` (CRAP < 10) and `dryer` (rank ≥ 0.8)
  after each slice → `mutator` once at the end → `code-review` → suggest a
  commit message → stop.
- Use unclebob's `crapper`, `dryer`, `mutator` (installed in `~/.local/bin`).
- Remove every commit, push and worktree-cleanup instruction.

### Issue tracker

- Remove every reference to `/setup-matt-pocock-skills`,
  `docs/agents/issue-tracker.md` and triage labels (`ready-for-agent`).
- `to-spec`: write `.scratch/<slug>.md`. Add `.scratch/` to the repo's
  `.gitignore` if it is missing. Never post.
- `to-tickets`: write local ticket files under `.scratch/<slug>/issues/`, then
  ask per ticket whether to post with `gh issue create`. Use the repo's
  `.github/ISSUE_TEMPLATE/` if it exists, else the skill's own template.
- `implement` and `code-review`: when out-of-scope work turns up, draft an issue
  and ask before posting.
- `code-review` spec lookup order: issue refs in commits (`gh issue view`), a
  path I pass, `.scratch/`.

### CLAUDE.md

A `CLAUDE.md` in this repo, installed as `~/.claude/CLAUDE.md`, with these
sections only:

1. Smallest change, no extras unless asked.
2. Prefer jj over git. Never commit or push; suggest a message instead.
3. Look up facts yourself; ask me for decisions.
4. Ask before any outward-facing action.
5. Short STE100 rules for chat replies, specs and issues (commit messages keep
   their own style). The full `asd-ste100` skill stays for explicit rewrites.
6. Workflow map: grill → (spec → tickets) → implement → review → commit message.

I commit.

## Phase 3: install tooling

A `justfile` that calls one `scripts/skills.sh`. Target: Claude Code only.

- `just install [force]`: symlink `~/.claude/skills/<name>` → `skills/<name>`
  for each tracked skill, and `~/.claude/CLAUDE.md` → `CLAUDE.md`. Replace
  existing symlinks silently. Skip real files and directories with a warning,
  unless `force` is given.
- `just uninstall <name>`: remove the symlink only if it points into this repo.
- `just status`: list the union of installed and tracked skills, each with one
  state: `linked`, `tracked, not installed`, `untracked` (experiment), or
  `conflict` (tracked, but the installed entry points elsewhere). Also show the
  state of `CLAUDE.md`.
- `just import <name>`: copy the installed skill (resolve the symlink) into
  `skills/<name>/` with the phase 1 exclusions, then replace the installed entry
  with a symlink into the repo. I commit.
- `~/.agents/skills` and its lockfile stay untouched.

I commit.
