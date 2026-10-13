---
name: dependency-check
description: Assess whether an open-source library, package, framework, GitHub Action or tool is healthy and worth depending on. Use before adding or upgrading a dependency, when comparing alternatives, or when asked whether a project is well maintained or trustworthy.
---

# Dependency check

Every dependency is code we run and maintain without controlling it. First ask whether it is
needed at all: the standard library or a few lines of our own code often beat a small package.

## Gather the facts

Use the package registry (npm, PyPI, pub.dev, crates.io, Maven Central, Go proxy) for releases
and downloads, and the source repository for activity. For GitHub repositories, run each `gh`
command on its own (not inside a pipe or loop), for example:

```sh
gh api repos/OWNER/REPO --jq '{stars: .stargazers_count, pushed: .pushed_at, archived, license: .license.spdx_id, open_issues: .open_issues_count}'
gh release list -R OWNER/REPO --limit 5
gh api 'repos/OWNER/REPO/contributors?per_page=10' --jq '.[] | "\(.login) \(.contributions)"'
gh issue list -R OWNER/REPO --state open --limit 10
gh pr list -R OWNER/REPO --state merged --limit 10
gh api repos/OWNER/REPO/security-advisories --jq '.[] | "\(.severity) \(.summary)"'
```

## Criteria

| Signal | Healthy | Warning |
|---|---|---|
| Releases | Regular, recent, semantic versioning | None in over a year, or 0.x for years with breaking changes |
| Activity | Commits and merged PRs in recent months | Archived, or issues and PRs unanswered |
| Maintainers | Several active people or an organisation | One person (bus factor 1) |
| Adoption | Widely used, used by projects we respect | Few users, or download spikes with no history |
| License | Compatible (MIT, Apache-2.0, BSD, MPL…) | Missing, copyleft where we can't comply, or recently changed |
| Security | Advisories fixed quickly, a security policy | Open unpatched advisories |
| Supply chain | Signed releases or provenance, few transitive deps | Install scripts, many transitive deps, typo-squat-like names |
| Fit | Small surface, stable API, good docs | Pulls in a framework for one function |

## Report

Summarise in a few lines: what it is for, the facts above with dates, the verdict
(adopt / adopt with caution / avoid), alternatives considered (including writing it ourselves),
and the exact version to pin.
