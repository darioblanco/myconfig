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
  Ephemeral preview environments per PR (created on open, destroyed on merge) are a strong green
  flag: they replace a shared staging branch and let every change be tested in isolation.
- **Infrastructure as code.** Coverage of the real infrastructure, drift, who can apply it.
- **Change safety.** Feature flags, and database migrations that are backwards compatible
  (expand, then contract) so any deploy can be rolled back without restoring data. Migrations
  that only work with a coordinated, all-at-once release are a red flag and often the real
  reason behind staging branches and release days.

## Mobile apps

App stores add two constraints: a shipped binary can't be rolled back, and old versions stay in
use for months. Good teams stay trunk-based and add a release train on top.

- **Development.** Small daily merges to `main`; unfinished features hidden behind remote
  feature flags; every merge built and delivered to internal testers automatically.
- **Release train.** A fixed cadence (weekly or fortnightly) that never waits for a feature.
  Releases are a tag on `main` or a short-lived release branch for stabilisation, where fixes
  land in `main` first and are cherry-picked over, and the branch is deleted after release.
- **Build once.** The build testers approved is promoted through the store stages (TestFlight,
  Play testing tracks) to production, never rebuilt.
- **Rollout safety.** Staged or phased rollouts halted on crash-rate drops; remote kill
  switches for risky features; a minimum-supported-version mechanism; over-the-air patching
  where the stack allows it (for example Shorebird for Flutter) for urgent fixes only.
- **Backend compatibility.** APIs stay compatible with the oldest supported app version
  (additive or versioned changes, contract tests against old clients).
- **Automation.** Signing, version numbers, release notes and store uploads are automated
  (fastlane, Codemagic, Bitrise, Xcode Cloud…).

Red flags: long-lived `develop` or `release` branches, manual builds or signing, rebuilding for
production, no way to switch a feature off after release, backend changes that break older app
versions.

## Operations

- **Observability.** Logs, metrics, tracing, dashboards; whether alerts exist, who receives
  them, and whether they fire on symptoms users notice.
- **Incidents.** On-call setup, postmortems, recurring incident causes. Ask for the last few.
- **Resilience.** Backups and whether restores are tested, disaster recovery, capacity limits.
- **Access and secrets.** Who has production access, how secrets are stored and rotated,
  audit logs, offboarding.

Useful evidence: CI workflow files and run history (`gh run list`), deployment manifests, IaC,
runbooks, alert definitions, the dates of the last restore test and the last postmortem.
