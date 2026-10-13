---
name: tdd
description: Test-driven development with testable design and 100% coverage. Use whenever writing or changing production code (new features, bug fixes, refactors), and whenever someone asks for tests, coverage, or "TDD".
---

# Test-driven development

The goal is code that is easy to test, tests that would catch a regression, and 100% coverage.
Writing the test first is the usual way to get there, not a ritual: what matters is that every
behaviour has a test that can fail.

## Design for testability

- Keep logic separate from I/O (network, database, filesystem, clock): pure functions or small
  units in the middle, thin adapters at the edges.
- Pass dependencies in at the boundaries instead of reaching for globals or singletons.
- If something is hard to test, change the design rather than the test strategy.

## The loop

1. **Test list.** Write down the behaviours to build, smallest first. Work through them one at
   a time; add new ideas to the list instead of building them now.
2. **Test first when the behaviour is clear.** Write the test, run it, and show the failing
   assertion (a failing assertion, not an import error or missing symbol). Then write just
   enough code to pass.
3. **Code first while exploring.** When the shape isn't clear yet, spike the code, then write
   the tests before moving on. Prove each one can fail: break the behaviour briefly (flip a
   condition, return early), confirm the test fails, restore it.
4. **Refactor** with everything green. If there's nothing worth changing, say so. Refactors go
   in their own commit.
5. During the loop run only the targeted tests; run the full suite and the coverage report
   once at the end.

## Bug fixes

Always test first: reproduce the bug in a failing test before touching the code, and keep the
test as a regression guard. If you can't reproduce it, find the root cause first (the
`systematic-debugging` skill).

## Tests that mean something

- Test behaviour through the public interface, not private helpers or call sequences.
- Mock only at real boundaries (network, clock, filesystem, third-party APIs). Never assert on
  what a mock did instead of what the code produced.
- One reason to fail, a name that says what broke, no logic in the test, deterministic (no
  sleeps, real time, unseeded randomness or ordering assumptions), clean output.

## Coverage policy

- The threshold stays at 100% (lines, and branches where the tool supports it).
- Exclusions are per line, each with an inline reason a reviewer can check, for example
  `# pragma: no cover - only reachable on Windows`. Never exclude whole files or directories.
- Never lower the threshold, or delete, skip or weaken a test to get green. If a test is wrong,
  say why before changing it.
- Uncoverable code is often a design smell: before excluding a line, ask whether it should exist.
