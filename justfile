# List installed and tracked skills with their state.
status:
    scripts/skills.sh status

# Symlink the tracked skills and CLAUDE.md into ~/.claude.
install force="":
    scripts/skills.sh install {{force}}

# Remove the symlink of a skill if it points into this repo.
uninstall name:
    scripts/skills.sh uninstall "{{name}}"

# Copy an installed skill into skills/ and link it back.
import name:
    scripts/skills.sh import "{{name}}"
