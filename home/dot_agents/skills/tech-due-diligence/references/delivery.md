# Delivery and operations review

How changes get to production, and what happens when something breaks there.

## Delivery

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
