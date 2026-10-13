---
name: team-practices
description: Assess how an engineering team works (review, delivery, ownership, AI judgement, atmosphere) from its repositories and tooling, against a defined set of good practices. Use for a technical due diligence, a health check of my own team, or when asked how a team reviews, ships, documents or shares knowledge.
---

# Team practices

This assesses the system the team works in, not the people in it.

- Report patterns for the team, never scores, rankings or quotes tied to named people.
- Assess individuals only in interviews, with their knowledge.
- Before analysing people's activity data, check the local privacy and labour rules (for
  example GDPR, works council agreements) and use only what the engagement allows.

## Gather evidence

In every important repository, over roughly the last 6 to 12 months, run each command on its
own:

```sh
git shortlog -sn --since="12 months ago"
git log --since="12 months ago" --format='%an' -- <critical-path> | sort | uniq -c | sort -rn
gh pr list --state merged --limit 200 --json number,additions,deletions,createdAt,mergedAt,reviews,comments,files
gh run list --limit 100 --json conclusion,createdAt,event
gh release list --limit 20
```

Also read: contribution guide, onboarding docs, ADRs, AGENTS.md or other AI guidelines,
CODEOWNERS, issue and incident templates, runbooks and postmortems.

## Good practices

Rate each green / amber / red with a confidence level.

1. **Review.** Every change reviewed; PRs small (under ~400 changed lines); first review
   within a working day.
2. **Streamlined delivery.** Trunk-based development with short-lived branches; every merge to
   main releasable; one artifact promoted through environments; feature flags instead of
   long-lived branches; backwards-compatible migrations; frequent deploys. Ephemeral preview
   environments per PR are a strong positive sign. Environment branches (`develop`, `staging`) and
   GitFlow are a red flag, except release branches for multi-version software and mobile
   app-store releases.
3. **CI as the gate.** Nothing merges red; flaky tests are fixed or removed, not rerun.
4. **Tests.** Testable design; coverage enforced in CI (use the `test-suite` skill).
5. **Shared ownership.** No critical area known by only one person; ownership files.
6. **Decisions written down.** ADRs for significant choices; docs next to the code.
7. **Operations.** On-call with runbooks; blameless postmortems with tracked follow-ups.
8. **Onboarding.** A new engineer can ship to production in their first week.
9. **Technical debt.** Visible, prioritised, with capacity reserved for it.
10. **Security hygiene.** Least-privilege access, central secrets, automated dependency updates.
11. **AI-assisted development.** Agents sandboxed; AI output reviewed like any other code;
    quality gates never bypassed.
12. **AI judgement.** Judge the current state of the code and process, not trends:
    - *Careless use (slop):* code rewritten soon after merging (from `git log`), duplicated
      blocks (a clone detector such as jscpd), dead code and unused dependencies, dense lint
      and type suppressions (`eslint-disable`, `@ts-ignore`, `# type: ignore`), verbose
      comments that restate the code, inconsistent patterns for the same problem, large PRs
      merged quickly with no discussion, changes without tests, generic commit messages.
    - *Judgement present:* meaningful AI guidelines in the repositories, PR descriptions that
      explain why, review threads where someone pushes back or asks for a simpler approach,
      consistent architecture, ADRs, small coherent commits.
    - *No AI at all* is a choice, not a fault: note it, and whether it was deliberate.
13. **Atmosphere.** Reviews are increasingly written by bots, so look at the human-written
    parts in aggregate: PR descriptions and discussion threads, issues, ADR debates and
    postmortems (blameless or blaming language), how disagreements end, contributor
    retention in the history, and sustained late-night or weekend work. Humour and
    friendliness are a pleasant but weak signal. Rate atmosphere low confidence unless
    interviews or an anonymous survey confirm it.

## Report

Per practice: the evidence (with numbers), rating and confidence, and one concrete improvement.
Then the questions that only interviews can answer, for example: "How do you use AI, and what
do you never delegate to it?", "Show me a change where the AI got something wrong", "What
happened in your last incident?".
