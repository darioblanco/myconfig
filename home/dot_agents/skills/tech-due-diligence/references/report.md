# Report

Write for a reader who will make a decision, not for engineers. Lead with the conclusion.

## Structure

1. **Executive summary.** Overall verdict in two or three sentences, the three biggest risks,
   and whether any is a deal-breaker.
2. **Scorecard.** One row per area (architecture, code and tests, dependencies, security,
   delivery and operations, team and practices) with a rating, a one-line reason and the
   confidence of the assessment.
3. **Findings.** Per area: what was observed (with evidence), why it matters, severity, and
   the effort to fix (days, weeks, months, or a team quarter).
4. **Remediation plan.** What to fix first and roughly what it costs, in order.
5. **Open questions.** What could not be verified and the interview questions that would
   answer it.
6. **Appendix.** Scope, repositories and commits reviewed, tools and versions used, dates.

## Ratings

| Rating | Meaning |
|---|---|
| Green | Sound; normal maintenance |
| Amber | Real gaps; fixable within normal roadmap capacity |
| Red | Material risk to the decision, or fixing it needs dedicated investment |

Confidence: high (verified directly), medium (partly verified or sampled), low (inferred or
reported by people). Never present a low-confidence finding as fact.
