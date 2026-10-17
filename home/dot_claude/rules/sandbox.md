# Claude Code sandbox on this machine

- `gcloud`, `terraform`, `kubectl`, `helm`, `docker`, `colima` and `git push/fetch/pull` run
  outside the sandbox, with my credentials, only as plain commands. Wrapped in `cd … &&`, a
  pipe, a loop or `git -C`, they stay sandboxed and fail as if logged out. Use
  `terraform -chdir=<dir>`, and write output to a file in the scratchpad to filter it.
- If one of them fails with a credential or permission error, rerun it as a plain command before
  concluding that access is blocked.
