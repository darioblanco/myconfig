---
name: systematic-debugging
metadata:
  inspired-by: obra/superpowers systematic-debugging (MIT)
description: Find the root cause of a bug, failing test, crash, flaky behaviour or unexpected output before changing code. Use whenever something doesn't work as expected, especially after a first fix attempt failed.
---

# Systematic debugging

Fixes based on guesses hide bugs or move them. Understand the cause first; the fix is usually
small once you do.

## 1. Reproduce

- Get an exact, repeatable reproduction: the command, the input, the full error and stack
  trace. Read the error message completely; it often names the cause.
- If it only fails sometimes, find what varies (timing, ordering, data, environment) and
  make it fail reliably before going further.
- Capture the reproduction as a failing test when you can.

## 2. Locate

- Check what changed: `git log`, `git diff`, dependency or config changes, environment.
- Compare with something similar that works, and list every difference.
- Trace the bad value backwards from where it shows up to where it was first wrong. Add
  temporary logging at component boundaries rather than guessing.
- Narrow down by bisecting: `git bisect`, halving the input, disabling half the path.

## 3. Hypothesise and test

- State one hypothesis: "X happens because Y". Make the smallest change that tests it, and only
  one change at a time.
- If it's wrong, undo the change and form a new hypothesis from what you learned. Don't stack
  speculative fixes.

## 4. Fix

- Fix the cause, not the symptom: no retries, sleeps, broad `try/except` or special cases that
  make the error disappear without explaining it.
- Keep the reproducing test, remove temporary logging, run the full suite.

## When to stop and escalate

After three fixes that didn't hold, stop: the problem is probably in the design, not the
line you're looking at. Summarise what you tried, what you learned and what you suspect, and
ask before going further.
