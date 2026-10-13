---
name: test-suite
description: Set up coverage tooling and enforcement for a repository, or audit how trustworthy an existing test suite is. Use when adding or fixing coverage reports and thresholds, wiring coverage into CI, or when asked whether a codebase's tests are any good (including as part of a technical due diligence).
---

# Test suite: set up and audit

Coverage says which lines ran, not whether anything was checked. A trustworthy suite needs
enforced coverage *and* tests that fail when behaviour breaks.

## Set up coverage

1. Find what exists: test runner, coverage config, CI workflow, how tests are run locally
   (Makefile, package scripts). Extend it rather than adding a second tool.
2. Measure lines and branches, fail below the required threshold, and make the
   same command run locally and in CI. Publish the report as a CI artifact.
3. Exclusions are per line with a reason; whole-file exclusions only for generated code, listed
   in the config with a comment.

Starting points (check each tool's current docs before configuring):

| Stack | Coverage and threshold | Line exclusion | Mutation testing |
|---|---|---|---|
| Python | coverage.py / pytest-cov, `branch = true`, `fail_under = 100` | `# pragma: no cover - reason` | mutmut |
| TypeScript | Vitest (v8) `coverage.thresholds`, or Jest `coverageThreshold` | `/* v8 ignore next */`, `/* istanbul ignore next */` | Stryker |
| Go | `go test -coverprofile`, threshold via a checker such as go-test-coverage | none native; isolate untestable code | gremlins |
| Rust | cargo-llvm-cov `--fail-under-lines` | `#[coverage(off)]` (nightly) | cargo-mutants |
| Dart / Flutter | `flutter test --coverage` (lcov), threshold via a checker | `// coverage:ignore-line` | limited tooling |
| Java / Kotlin | JaCoCo `check` rule | none per line | PIT |

## Audit a suite

Gather facts, then judge. Run things; don't infer from file names.

1. **Runs and speed.** Does the suite run with one documented command, locally and in CI? How
   long does it take? Any skipped, quarantined or flaky tests (check CI history for reruns)?
2. **Coverage.** Line and branch numbers per module, whether a threshold is enforced in CI,
   and every exclusion with its justification. Untested code in critical paths (auth, money,
   data writes, migrations) matters more than the total.
3. **Meaning.** Sample tests in the riskiest modules: tests without assertions, assertions only
   on mocks, snapshot tests nobody reads, logic inside tests, sleeps and real time, tests that
   mirror the implementation line by line.
4. **Can they fail?** Run mutation testing on one or two critical modules (or break a few
   behaviours by hand) and report how many changes the suite caught.
5. **Shape.** Balance of unit, integration and end-to-end tests; whether external services are
   faked locally; whether tests can run in parallel.

Report: a one-line verdict, the facts above with numbers, the three highest-risk gaps, and a
prioritised plan to fix them (enforcement first, then critical-path tests, then quality).
