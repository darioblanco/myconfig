# Personal engineering rules

These apply in every project. A repository's own AGENTS.md or CLAUDE.md wins where they disagree,
and it is where the project's commands live: read it (or the README and Makefile) first and use
its exact commands for formatting, linting, type checks and tests.

## Working style
- Routine changes: just do them. New features, new modules, changes that cross a module boundary
  or add a public interface: first write a short plan (approach, boundaries, failure modes, test
  strategy) and stop for my OK, using plan mode where the tool has one. In non-interactive runs
  (`claude -p`, `codex exec`, background agents) put the plan at the top of your output and
  proceed.
- Make the smallest change that solves the problem, in the style of the surrounding code. No
  unrequested features, no new abstraction without a second real use, no compatibility shims or
  fallbacks unless I ask.
- Find the root cause before fixing. Don't patch symptoms.
- Don't invent APIs, flags or facts. Check the source or the docs, or say you don't know.
- Make failures visible: precise errors and useful logs. Never swallow exceptions.

## Tests
- Red/green TDD: write the test, watch it fail, write just enough code to pass, then refactor.
- Bug fixes start with a test that reproduces the bug.
- Coverage stays at 100%. Exclude only single lines, each with an inline reason. Never lower the
  threshold, or delete, skip or weaken tests to get green; test behaviour, not mocks.
- Before saying you're done, run the repo's format, lint, type-check and test commands, and
  report what ran and the result. Output should be clean: no new warnings.

## Review
- Before opening a PR, review the diff with the native tool (`/code-review` in Claude Code,
  `/review` in Codex). For risky changes (auth, data migrations, infrastructure), get a second
  review from the other model: `codex review` from Claude Code, `claude -p /code-review` from
  Codex.

## Dependencies
- Prefer the standard library or a few lines of code. Before adding a dependency, check that it
  is healthy (recent releases, active maintainers, adoption, license, advisories) and report
  what you found.

## Safety
- Test against local resources (containers, emulators, fakes). Never use staging or production
  credentials, data or clusters unless I ask.
- Ask before infrastructure changes and anything destructive or irreversible. Never print secret
  values.
- Uncommitted changes you didn't make belong to me or another agent: leave them alone and
  mention them.

## Git
- Conventional Commits, small and focused. Don't mix refactors with behaviour changes in one
  commit. Stage files explicitly (no `git add -A`) and don't amend unless asked.
- Work on a feature branch; pushing it and opening a PR is fine. Never push to the default
  branch, never force-push a branch someone else works on, and never bypass hooks
  (`--no-verify`). No AI attribution: no `Co-Authored-By` trailers or "Generated with" lines.

## Keeping this file useful
- When an agent repeats a mistake, add one line here or in the repo's AGENTS.md to prevent it.
  One-off learnings belong in the agent's own memory, not here, so this file stays short.
