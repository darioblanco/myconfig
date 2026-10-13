---
name: tdd
description: Red/green test-driven development with 100% coverage. Use whenever writing or changing production code (new features, bug fixes, refactors), and whenever someone asks for tests, coverage, or "TDD".
---

# Test-driven development

A test you never saw fail proves nothing: it may not exercise the code at all. Coverage is a
floor, not a goal: it shows nothing important was left untested.

## The loop

1. **Test list.** Write down the behaviours to build, smallest first. Work through them one
   test at a time; add new ones to the list instead of building them now.
2. **Red.** Write the test for the next behaviour and run it. It must fail on an assertion
   about the missing behaviour, not on an import error, typo or missing symbol. **Show the
   failing assertion line** before writing any production code. If the test passes straight
   away, the test is wrong or the behaviour already exists: fix the test first.
3. **Green.** Write just enough code to make that test pass. No extra branches "while you're
   there". Run the test, then the related suite.
4. **Refactor.** With everything green, improve names and structure, and run the tests again.
   If there's nothing worth changing, say "nothing to refactor" rather than skipping silently.
   Refactors change no behaviour, so they go in their own commit.
5. When the list is done, run the full suite and the coverage report.

## Bug fixes

Write a test that reproduces the bug and show it failing before touching the code. The test
stays as a regression guard. If you can't reproduce it in a test, find the root cause first
(the `systematic-debugging` skill) instead of guessing at a fix.

## Tests that mean something

- Test behaviour through the public interface, not private helpers or call sequences.
- Mock only at real boundaries (network, clock, filesystem, third-party APIs). Never assert on
  what a mock did instead of what the code produced.
- One reason to fail, a name that says what broke, no logic in the test, deterministic (no
  sleeps, real time, unseeded randomness or ordering assumptions), clean output.
- For critical logic, check the test can catch a bug: briefly break the code (flip a condition,
  return early), confirm the test fails, then restore it.

## Coverage policy

- The threshold stays at 100% (lines, and branches where the tool supports it).
- Exclusions are per line, each with an inline reason a reviewer can check, for example
  `# pragma: no cover - only reachable on Windows`. Never exclude whole files or directories.
- Never lower the threshold, or delete, skip or weaken a test to get green. If a test is wrong,
  say why before changing it.
- Uncoverable code is often a design smell: before excluding a line, ask whether it should exist.
