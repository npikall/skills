---
name: to-skill
description: Adapt the skills in this repo to the way I work, and record the edit as one jj change for later review.
argument-hint: "What should change?"
disable-model-invocation: true
---

# To skill

The user tells you what should change in their skills. You edit the skills
repo and record the work as one jj change. The user reviews it later, often
without this conversation at hand, so the change must explain itself.

## 1. Find the repo

The skill's base directory is a symlink into the skills repo. Resolve it:

```sh
dirname "$(dirname "$(realpath <base directory>)")"
```

The result is `<repo>`. It must contain a `.jj` directory. Run every jj
command as `cd <repo> && jj …` in one Bash call, because `jj -R` is blocked.

## 2. Check the working copy

Run `cd <repo> && jj st`. If `@` holds changes, stop. Tell the user that those
changes are theirs, and that your description would claim them as your work.

## 3. Understand the request

The user's arguments decide what changes. If there are none, ask what should
change.

Use the current session as evidence. Find the passage where a skill misled you
or where the user corrected you, and the file and wording behind it.

Restate the request. Name the files you will change. If the request is
ambiguous, ask one round of questions. Otherwise continue without waiting for
approval.

## 4. Edit

Call the Skill tool with "writing-for-agents" before you edit. Edit only these
files:

- existing skills in `skills/*/`
- `CLAUDE.md`
- `README.md`, wherever your edit makes it wrong

If the request needs a new skill, a deleted skill, or an edit to other files,
stop. Tell the user in one line.

The step is done when every part of the request is in the files and
`README.md` still matches them.

## 5. Record the change

1. Call the Skill tool with "writing-commit-messages" to draft the message. It
   only drafts. You run the commands below. End the body with the line
   `Requested via /to-skill: "<the user's request>"`.
2. Run `jj desc` with a quoted heredoc. The heredoc keeps quotes, backticks
   and `$` in the request intact:

   ```sh
   cd <repo> && jj desc -m "$(cat <<'EOF'
   <message>
   EOF
   )"
   ```

3. Run `cd <repo> && jj new`.

Make one change per run. Use only these two state-changing jj commands.

Report the change ID and the subject line to the user.
