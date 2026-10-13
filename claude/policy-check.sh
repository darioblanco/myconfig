#!/bin/sh
# Fail if the Claude Code policy loses any protection recorded in claude/policy-baseline.json.
# Removing a rule therefore needs a change to both files, which stands out in review.
#   claude/policy-check.sh           check
#   claude/policy-check.sh --update  rewrite the baseline from the current policy
set -eu
cd "$(dirname "$0")/.."
current=$(echo '{}' | sh home/dot_claude/modify_settings.json | jq -S '{
  sandbox_enabled: .sandbox.enabled,
  login: .forceLoginMethod,
  denyRead: (.sandbox.filesystem.denyRead | sort),
  envVars: ([.sandbox.credentials.envVars[].name] | sort),
  deny: (.permissions.deny | sort),
  ask: (.permissions.ask | sort)
}')
if [ "${1:-}" = "--update" ]; then
	printf '%s\n' "$current" >claude/policy-baseline.json
	exit 0
fi
printf '%s' "$current" | jq -e --slurpfile base claude/policy-baseline.json '
  . as $now | $base[0] as $b |
  ($now.sandbox_enabled == true) and ($now.login == $b.login) and
  all(["denyRead", "envVars", "deny", "ask"][]; . as $k | ($b[$k] - $now[$k]) == [])
' >/dev/null || {
	echo "Claude Code policy is weaker than claude/policy-baseline.json" >&2
	exit 1
}
