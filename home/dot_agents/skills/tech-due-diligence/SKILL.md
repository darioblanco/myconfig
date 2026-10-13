---
name: tech-due-diligence
description: Run a technical due diligence on a codebase or engineering organisation and write an evidence-based report. Use when asked for a due diligence, a technical assessment of a company, product or acquisition target, or a health check of an unfamiliar system.
---

# Technical due diligence

The output is a decision aid: what is solid, what is risky, what it would cost to fix. Every
finding needs evidence (a file, a command and its output, a number) and a confidence level.
Separate what you observed from what you conclude.

## Before starting

- Confirm the scope with me: which repositories and systems, what decision the DD supports
  (investment, acquisition, hiring a team, internal health check), the timebox, and what is
  confidential.
- Work read-only on the target: no commits, pushes, issues or changes to their systems. Never
  copy secrets into notes or the report; note that one exists and where.
- Work in a dedicated directory with the repositories cloned under it. For architecture and
  inventory, the `code-modernization` plugin helps, but it is heavy (hooks on every prompt), so
  enable it only for that directory and remove it afterwards:
  `claude plugin install code-modernization@claude-plugins-official --scope local` and
  `claude plugin uninstall code-modernization@claude-plugins-official --scope local`.
  Ask me to run these; don't install it globally.

## Order of work

Keep notes per area as you go, in `dd/notes/<area>.md`.

1. **Orientation.** READMEs, docs, ADRs, the size and age of each repository (languages, lines,
   commits, contributors). With the plugin enabled, `/modernize-assess` and `/modernize-map`
   give an inventory and a structure map.
2. **Architecture.** Follow [references/architecture.md](references/architecture.md).
3. **Code and tests.** Use the `test-suite` skill to audit each important repository.
4. **Dependencies.** Run the ecosystem's audit (`npm audit`, `pip-audit`, `cargo audit`,
   `osv-scanner`…) for known vulnerabilities, and the `dependency-check` skill on the few
   dependencies the product depends on most.
5. **Security.** Run the `claude-security` scan on the main repositories and gitleaks on their
   full history. Review authentication, authorisation and handling of personal or sensitive
   data by reading the code paths, not just tool output.
6. **Delivery and operations.** Follow [references/delivery.md](references/delivery.md).
7. **Team and practices.** Use the `team-practices` skill.
8. **Report.** Follow [references/report.md](references/report.md).

When something can only be answered by people (incident history, roadmap, hiring plans), add it
to a list of interview questions instead of guessing.
