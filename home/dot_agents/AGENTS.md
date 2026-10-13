# Personal engineering rules

These apply in every project. A repository's own AGENTS.md or CLAUDE.md wins where they disagree,
and it is where the project's commands live: read it (or the README and Makefile) first and use
its exact commands for formatting, linting, type checks and tests.

## Working style
- Routine changes: just do them. New features, new modules, changes that cross a module boundary
  or add a public interface: first write a short plan (approach, boundaries, failure modes, test
  strategy) and stop for my OK, using plan mode where the tool has one. If nobody can answer
  (an unattended background run), put the plan at the top of your output and proceed.
- Make the smallest change that solves the problem, in the style of the surrounding code. No
  unrequested features, no new abstraction without a second real use, no compatibility shims or
  fallbacks unless I ask.
- Find the root cause before fixing. Don't patch symptoms.
- Don't invent APIs, flags or facts. Check the source or the docs, or say you don't know.
- Make failures visible: precise errors and useful logs. Never swallow exceptions.

## Tests
- Design code to be easy to test: logic separate from I/O, dependencies passed in at the
  boundaries, small units. Hard-to-test code is a design problem, not a testing one.
- Every behaviour change ships with its tests in the same change. Work from a short test list,
  one behaviour at a time. Test-first is the default when the behaviour is clear; writing the
  code first is fine while exploring, as long as the tests exist before you're done. Bug fixes
  always start with a test that reproduces the bug.
- Prove each new test can fail: show it failing on an assertion before the code exists, or break
  the behaviour briefly and watch it fail.
- Test behaviour through public interfaces. Mock only at real boundaries (network, clock,
  filesystem, third-party APIs). Tests are deterministic: no sleeps, real time or unseeded
  randomness.
- Coverage stays at 100%. Exclude only single lines, each with an inline reason. Never lower the
  threshold, or delete, skip or weaken tests to get green.
- Run targeted tests while working. Before saying you're done, run the repo's format, lint,
  type-check, full test and coverage commands, and report what ran and the result. Output
  should be clean: no new warnings.

## Review
- Before opening a PR, review the diff with the native tool (`/code-review` in Claude Code,
  `/review` in Codex). For risky changes (auth, data migrations, infrastructure), suggest a
  second review from the other model, which I run in its own interactive session.

## Dependencies
- Prefer the standard library or a few lines of code. Before adding a dependency, check that it
  is healthy (recent releases, active maintainers, adoption, license, advisories) and report
  what you found.

## Safety
- Use the subscription logins only. Never call model APIs with API keys, and don't launch other
  agents headless (`claude -p`, `codex exec`); suggest the session for me to start instead.
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
