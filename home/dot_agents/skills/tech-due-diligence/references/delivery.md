# Delivery and operations review

How changes get to production, and what happens when something breaks there.

## Delivery

The target is a streamlined flow: trunk-based development, every merge to the main branch
releasable, one build artifact promoted through environments, and feature flags instead of
long-lived branches.

- **Branching.** Short-lived branches (hours to a few days) merged into one main branch. Red
  flags: GitFlow-style `develop` / `staging` / `release` branches, a branch per environment,
  merges between them, regular cherry-picks and hotfix branches, code freezes, a "release day".
  Legitimate exceptions: release branches for software with several supported versions
  (libraries, SDKs, on-premise products) and app-store releases for mobile apps.
- **Promotion.** Build once, deploy the same artifact (image digest, package version) to every
  environment, with configuration as the only difference. Red flags: rebuilding per environment,
  environment-specific code paths, manual steps between environments.
- **Flow metrics.** Estimate from the history: deployment frequency, lead time from merge to
  production, change failure rate (reverts, hotfixes, rollbacks) and time to restore. These are
  the DORA metrics; elite teams deploy on demand with lead times under a day.
- **CI.** What runs on every change (build, lint, tests, coverage, security scans); duration;
  pass rate and reruns from recent history.
- **CD.** How releases happen (manual steps, approvals, scripts), frequency, and rollback.
- **Environments.** Which exist, how close staging is to production, how test data is handled.
- **Infrastructure as code.** Coverage of the real infrastructure, drift, who can apply it.
- **Change safety.** Feature flags, database migration practice, backwards compatibility.

## Operations

- **Observability.** Logs, metrics, tracing, dashboards; whether alerts exist, who receives
  them, and whether they fire on symptoms users notice.
- **Incidents.** On-call setup, postmortems, recurring incident causes. Ask for the last few.
- **Resilience.** Backups and whether restores are tested, disaster recovery, capacity limits.
- **Access and secrets.** Who has production access, how secrets are stored and rotated,
  audit logs, offboarding.

Useful evidence: CI workflow files and run history (`gh run list`), deployment manifests, IaC,
runbooks, alert definitions, the dates of the last restore test and the last postmortem.
