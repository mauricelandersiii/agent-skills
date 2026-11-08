# agent-skills

My personal agent skills for Claude Code and Cursor.

## Install

```sh
git clone https://github.com/mauricelandersiii/agent-skills ~/Developer/agent-skills
~/Developer/agent-skills/install.sh
```

`install.sh` symlinks each folder in `skills/` into `~/.claude/skills/` and `~/.cursor/skills/`, so every project picks them up. Edit the skills here; `git pull` updates them everywhere.

Adding a skill: create `skills/<name>/SKILL.md`, then rerun `install.sh`.
