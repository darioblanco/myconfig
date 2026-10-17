# Personal engineering rules

These apply in every project; a repository's own AGENTS.md wins where they disagree. Use the
repository's own commands for formatting, linting, type checks and tests.

## Working style
- Routine changes: just do them. New features, new modules, changes that cross a module boundary
  or add a public interface: first write a plan with the `plan-architecture` skill and stop for
  my OK, using plan mode where the tool has one. If nobody can answer (an unattended
  background run), put the plan at the top of your output and proceed.
- Make the smallest change that solves the problem, in the style of the surrounding code. No
  unrequested features, no new abstraction without a second real use, no compatibility shims or
  fallbacks unless I ask.
- Find the root cause before fixing (the `systematic-debugging` skill). Don't patch symptoms or
  swallow errors to make them go away.
- Don't invent APIs, flags or facts. Check the source or the docs, or say you don't know.

## Design
- Get the data structures right first. Restructure until special cases disappear instead of
  adding branches for them.
- Dependencies point one way: no cycles between modules, and I/O and frameworks stay at the
  edges.
- Every network or remote call has a timeout and can be cancelled. No fire-and-forget tasks;
  queues are bounded.
- Public APIs change only additively: never remove, rename or repurpose a field or endpoint
  without a new version. Errors share one shape.

## Tests
- Design code to be easy to test: logic separate from I/O, dependencies passed in at the
  boundaries, small units. Hard-to-test code is a design problem, not a testing one.
- Every behaviour change ships with its tests in the same change. Test-first is the default when
  the behaviour is clear; code-first is fine while exploring, as long as the tests exist before
  you're done. Bug fixes always start with a test that reproduces the bug.
- Prove each new test can fail: show it failing on an assertion before the code exists, or break
  the behaviour briefly and watch it fail.
- Test behaviour through public interfaces. Mock only at real boundaries (network, clock,
  filesystem, third-party APIs), and prefer a real local stand-in (an in-process test server, a
  container) to a mock of your own client. Tests are deterministic.
- Test the failure paths, not just the happy path: errors, timeouts, partial writes and
  malformed input at each boundary. Fuzz or property-test code that parses untrusted input.
- Coverage stays at 100%. Exclude only single lines, each with an inline reason. Never lower the
  threshold, or delete, skip or weaken tests to get green.
- Run targeted tests while working. Before saying you're done, run the format, lint, type-check,
  full test and coverage commands, and report what ran and the result.

## Dependencies
- Prefer the standard library or a few lines of code. Before adding or upgrading a dependency,
  run the `dependency-check` skill and report what you found.
- Use the repo's lockfile and package manager. Never approve new install scripts or bypass a
  release-age cooldown without asking me.

## Safety
- Test against local resources (containers, emulators, fakes). Never use staging or production
  credentials, data or clusters unless I ask.
- Other agents may be working in parallel. Leave changes you didn't make alone, mention them,
  and stage only your own files.

## Git and review
- Conventional Commits, small and focused. Don't mix refactors with behaviour changes in one
  commit. Each commit builds and passes the tests on its own, and its message says why, not
  just what. Never bypass hooks (`--no-verify`).
- Work on a feature branch; pushing it and opening a PR is fine, but never push to the default
  branch.
- Before opening a PR, review the diff with the native tool (`/code-review` in Claude Code,
  `/review` in Codex). For risky changes (auth, data migrations, infrastructure), suggest a
  second review from the other model.
