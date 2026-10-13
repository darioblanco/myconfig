---
name: tdd
description: Red/green test-driven development with 100% coverage. Use whenever writing or changing production code (new features, bug fixes, refactors), and whenever someone asks for tests, coverage, or "TDD".
---

# Test-driven development

Tests come first because a test you never saw fail proves nothing: it may not exercise the code
at all. Coverage is a floor, not a goal: it shows nothing important was left untested.

## The loop

1. **Pick one behaviour.** The smallest next thing the code should do. One test at a time.
2. **Red.** Write a test for it and run it. It must fail, and for the expected reason (an
   assertion about the missing behaviour, not an import error or a typo). If it passes straight
   away, the test is wrong or the behaviour already exists: fix the test before writing code.
3. **Green.** Write just enough code to make that test pass. No extra branches "while you're
   there". Run the test, then the related suite.
4. **Refactor.** With everything green, improve names and structure. Run the tests again.
   Refactors change no behaviour, so they go in their own commit.
5. Repeat until the plan is done, then run the full suite and the coverage report.

## Bug fixes

Write a test that reproduces the bug and watch it fail before touching the code. The test stays
as a regression guard. If you can't reproduce it in a test, find the root cause first (see the
`systematic-debugging` skill) instead of guessing at a fix.

## What a good test looks like

- Tests behaviour through the public interface, not private helpers or call sequences.
- Mocks only at real boundaries (network, clock, filesystem, third-party APIs). Never assert on
  what a mock did instead of what the code produced.
- One reason to fail, a name that says what behaviour broke, no logic (loops, conditionals).
- Deterministic: no sleeps, real time, random data without a seed, or ordering assumptions.
- Clean output: no stray prints, warnings or skipped tests left behind.

## Coverage policy

- The project's coverage threshold stays at 100% (lines and branches where the tool supports it).
- Exclusions are per line, each with an inline reason a reviewer can check, for example
  `# pragma: no cover - only reachable on Windows` or `/* istanbul ignore next: defensive, unreachable */`.
  Never exclude whole files or directories to hit the number.
- Never lower the threshold, delete, skip, or weaken a test to get green. If a test is wrong,
  say so and explain why before changing it.
- Uncoverable code is often a design smell: before excluding a line, ask whether it should exist.

## Before calling it done

Run the repository's own format, lint, type-check, test and coverage commands (from its
AGENTS.md, README or Makefile) and report each one with its result.
