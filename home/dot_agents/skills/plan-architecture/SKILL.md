---
name: plan-architecture
description: Write a design plan before building something non-trivial. Use for new features, new services or modules, changes that cross a module boundary or add a public interface, data model or API changes, and whenever someone asks to plan, design or architect something.
---

# Architecture plan

The goal is to make the important decisions explicit and cheap to change before any code
exists, and to agree on them. This skill defines what a plan contains. For approval, present the
plan and stop (plan mode where the tool has one); in non-interactive runs, put the plan at the
top of the output and proceed.

## Before writing

- Read the relevant code, the repository's AGENTS.md and docs, and similar existing features.
  Follow the established patterns unless there is a reason not to, and say what it is.
- If the request is ambiguous, ask the few questions that change the design, one at a time.

## The plan

Keep it to a page. Write it in the conversation, or in `docs/plans/<topic>.md` if the
repository keeps plans.

1. **Goal and non-goals.** What changes for the user or system, and what is explicitly out of
   scope.
2. **Approach.** The design in a few sentences. If there were real alternatives, name them and
   why this one wins (simplicity, reversibility, fit with the codebase).
3. **Boundaries.** Which modules, services or packages change; new public interfaces (functions,
   endpoints, events, schemas) with their shapes; who owns what. Dependencies point one way,
   with no cycles.
4. **Data flow.** How data enters, moves and is stored, including migrations and
   backwards compatibility for stored data and APIs.
5. **Failure modes.** What can fail (dependencies down, bad input, partial writes, retries,
   concurrency), how each is handled, and how it becomes visible (errors, logs, metrics).
   Remote calls have timeouts and cancellation, and queues have a bound and a policy for when
   they are full.
6. **Performance.** Only for hot paths: the expected load, the data structures chosen for its
   access pattern, and the benchmark on realistic data that will show it holds. Measure before
   optimising.
7. **Security and privacy.** Authentication, authorisation, secrets, personal or sensitive data,
   and what gets logged.
8. **Test strategy.** Which behaviours get unit, integration or end-to-end tests, what runs
   locally (containers, emulators, fakes), and how coverage stays at the required threshold.
9. **Steps.** Small, independently testable increments in order, each ending green.
10. **Risks and open questions.**

## After approval

Implement step by step, each step with its tests. If reality contradicts the plan, stop and say what
changed instead of silently diverging.
