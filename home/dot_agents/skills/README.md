# Personal agent skills

One folder per skill, each with a `SKILL.md` ([Agent Skills](https://agentskills.io) format).
Codex and pi read `~/.agents/skills` natively; Claude Code reads it through the
`~/.claude/skills` symlink. Every skill's name and description is loaded into every session,
so add a skill only when it earns that cost; project-specific skills belong in the
repository's `.agents/skills`.
