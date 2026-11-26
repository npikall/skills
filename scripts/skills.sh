#!/usr/bin/env bash
# Install the skills in this repo into Claude Code as symlinks.
# Set CLAUDE_DIR to use a target other than ~/.claude.
set -euo pipefail
shopt -s nullglob

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
claude="${CLAUDE_DIR:-$HOME/.claude}"
installed="$claude/skills"

warn() { echo "warning: $*" >&2; }
die() { echo "error: $*" >&2; exit 1; }

# Reject names that leave skills/ or that are not skills.
check_name() {
  [[ $1 != */* && $1 != synced && $1 != . && $1 != .. ]] || die "invalid skill name: $1"
}

tracked_names() { for d in "$repo"/skills/*/; do basename "$d"; done; }

# Installed skill names. synced/ holds claude.ai skills and is not a skill.
installed_names() {
  for e in "$installed"/*; do
    [[ $(basename "$e") == synced ]] || basename "$e"
  done
}

# State of the entry at $1 that should link to $2.
link_state() {
  if [[ ! -e $1 && ! -L $1 ]]; then echo "not installed"
  elif [[ -L $1 && $(readlink "$1") == "$2" ]]; then echo "linked"
  else echo "conflict"
  fi
}

# Link $2 -> $1. Replace a symlink. Replace a real entry only if $3 is force.
link() {
  if [[ -e $2 && ! -L $2 ]]; then
    if [[ $3 != force ]]; then
      warn "skip $2: not a symlink (use force to replace)"
      return
    fi
    rm -rf "$2"
  fi
  ln -sfn "$1" "$2"
}

cmd_install() {
  [[ ${1:-} == "" || $1 == force ]] || die "usage: install [force]"
  mkdir -p "$installed"
  for name in $(tracked_names); do
    link "$repo/skills/$name" "$installed/$name" "${1:-}"
  done
  link "$repo/CLAUDE.md" "$claude/CLAUDE.md" "${1:-}"
}

cmd_uninstall() {
  local name=${1:?usage: uninstall <name>}
  check_name "$name"
  local entry="$installed/$name"
  [[ -L $entry && $(readlink "$entry") == "$repo"/* ]] ||
    die "$entry is not a symlink into $repo"
  rm "$entry"
}

# Print $2 in the SGR color $1 if stdout is a terminal and NO_COLOR is unset.
paint() {
  if [[ -t 1 && -z ${NO_COLOR:-} ]]; then
    printf '\e[%sm%s\e[0m\n' "$1" "$2"
  else
    echo "$2"
  fi
}

# Read "state<TAB>name" lines. Print the names with state $1 under the header $3 in color $2.
print_group() {
  local names count
  names=$(awk -F'\t' -v state="$1" '$1 == state { print "  " $2 }')
  [[ -n $names ]] || return 0
  count=$(wc -l <<<"$names" | tr -d ' ')
  paint "$2" "$3 ($count)"
  echo "$names"
}

entry_states() {
  local tracked name
  tracked=$(tracked_names)
  for name in $( (echo "$tracked"; installed_names) | sort -u); do
    if grep -qxF -- "$name" <<<"$tracked"; then
      printf '%s\t%s\n' "$(link_state "$installed/$name" "$repo/skills/$name")" "$name"
    else
      printf 'untracked\t%s\n' "$name"
    fi
  done
  printf '%s\tCLAUDE.md\n' "$(link_state "$claude/CLAUDE.md" "$repo/CLAUDE.md")"
}

cmd_status() {
  local entries
  entries=$(entry_states)
  print_group linked 32 linked <<<"$entries"
  print_group untracked 2 untracked <<<"$entries"
  print_group "not installed" 33 "tracked, not installed" <<<"$entries"
  print_group conflict 31 conflict <<<"$entries"
}

cmd_import() {
  local name=${1:?usage: import <name>}
  check_name "$name"
  local entry="$installed/$name" dest="$repo/skills/$name"
  [[ -d $entry ]] || die "$entry is not an installed skill"
  [[ ! -L $entry || $(readlink "$entry") != "$dest" ]] || die "$name is imported already"
  # If dest exists, an earlier run stopped after the copy. Skip to the link.
  if [[ ! -e $dest ]]; then
    mkdir -p "$dest"
    cp -RL "$entry/." "$dest/"
    rm -rf "$dest/agents/openai.yaml" "$dest/.claude-plugin" "$dest/README.md"
    rmdir "$dest/agents" 2>/dev/null || true
  fi
  rm -rf "$entry"
  ln -s "$dest" "$entry"
}

case ${1:-} in
  install | uninstall | status | import) cmd="$1"; shift; "cmd_$cmd" "$@" ;;
  *) die "usage: $0 install [force] | uninstall <name> | status | import <name>" ;;
esac
