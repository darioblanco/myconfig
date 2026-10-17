# Claude Code sandbox on this machine

- Tools that need my credentials (cloud CLIs, infrastructure, containers, git network commands)
  are listed in `sandbox.excludedCommands` in `~/.claude/settings.json`. They run outside the
  sandbox only as plain commands. Wrapped in `cd … &&`, a pipe, a loop or `git -C`, they stay
  sandboxed and fail as if logged out, and so do the same tools called from a script or Makefile
  target. Use the tool's own directory flag (such as `terraform -chdir`) instead of `cd`, and
  write output to a file in the scratchpad to filter it.
- If a command fails with a credential, network or permission error, check whether it is on that
  list and rerun it as a plain command before concluding that access is blocked. If it isn't on
  the list, tell me which tool needs access instead of working around the sandbox.
