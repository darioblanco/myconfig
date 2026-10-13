---
name: dependency-check
description: Assess whether an open-source library, package, framework, GitHub Action or tool is healthy and worth depending on. Use before adding or upgrading a dependency, when comparing alternatives, or when asked whether a project is well maintained or trustworthy.
---

# Dependency check

Every dependency is code we run and maintain without controlling it. First ask whether it is
needed at all: the standard library or a few lines of our own code often beat a small package.

## Gather the facts

Use the package registry (npm, PyPI, pub.dev, crates.io, Maven Central, Go proxy) for releases
and downloads, and the source repository for activity. For GitHub repositories (in sandboxes,
`gh` may only have credentials when run as a plain top-level command), for example:

```sh
gh api repos/OWNER/REPO --jq '{stars: .stargazers_count, pushed: .pushed_at, archived, license: .license.spdx_id, open_issues: .open_issues_count}'
gh release list -R OWNER/REPO --limit 5
gh api 'repos/OWNER/REPO/contributors?per_page=10' --jq '.[] | "\(.login) \(.contributions)"'
gh issue list -R OWNER/REPO --state open --limit 10
gh pr list -R OWNER/REPO --state merged --limit 10
# Advisories against the package (ecosystem: npm, pip, pub, rubygems, go, rust, maven…)
gh api 'advisories?ecosystem=npm&affects=PACKAGE' --jq '.[] | "\(.severity) \(.summary) \(.vulnerabilities[0].vulnerable_version_range)"'
```

[osv.dev](https://osv.dev) covers the same advisories across ecosystems.

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
| Publishing | Publishes from CI with provenance or trusted publishing | Recent maintainer or ownership change, release very different from its source tag |
| Fit | Small surface, stable API, good docs | Pulls in a framework for one function |

## Supply chain

- **Is it the right package?** Check the exact name against the project's own docs or
  repository link; agents hallucinate plausible names and attackers register them
  ("slopsquatting"), and look-alike names imitate popular packages.
- **How new is the version?** Prefer versions that have been public for a few days. pnpm
  enforces this by default (`minimumReleaseAge`); for uv, `exclude-newer` does the same per
  project. Most compromised releases are caught within hours to days.
- **Does it run code on install?** List `preinstall`/`postinstall` scripts and native builds.
  pnpm and Bun block them until approved; npm runs them unless `--ignore-scripts`.
- **Is it pinned?** Exact versions in a committed lockfile, installed with the frozen or locked
  mode (`pnpm install --frozen-lockfile`, `npm ci`, `uv sync --locked`); GitHub Actions pinned
  to a commit SHA.

## Report

Summarise in a few lines: what it is for, the facts above with dates, the verdict
(adopt / adopt with caution / avoid), alternatives considered (including writing it ourselves),
and the exact version to pin.
