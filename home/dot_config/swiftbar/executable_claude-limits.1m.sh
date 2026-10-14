#!/bin/sh
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# SwiftBar plugin (refreshes every minute): Claude plan limits left, from the numbers the Claude
# Code status line saves. Shows the 5-hour window in the menu bar and details in the dropdown.
jq=$(command -v jq || echo /opt/homebrew/bin/jq)
file="$HOME/.cache/claude-limits.json"

if [ ! -f "$file" ]; then
	echo "✻ –"
	echo "---"
	echo "Open a Claude Code session to load your limits"
	exit 0
fi

# shellcheck disable=SC2016 # jq expressions, not shell
"$jq" -r '
  def until(t): (t - now) as $s
    | if t == null or $s <= 0 then "now"
      elif $s >= 86400 then "\($s / 86400 | round) days"
      elif $s >= 3600 then "\($s / 3600 | round) h"
      else "\([$s / 60 | round, 1] | max) min" end;
  def ago(t): ((now - t) / 60 | round) as $m
    | if $m < 1 then "just now" elif $m < 60 then "\($m) min ago" else "\($m / 60 | round) h ago" end;
  (if .five_hour_left < 20 then " | color=#d97757" else "" end) as $warn
  | "✻ \(.five_hour_left)%\($warn)",
    "---",
    "5 hours: \(.five_hour_left)% left · resets in \(until(.five_hour_resets_at))",
    "Weekly: \(.seven_day_left)% left · resets in \(until(.seven_day_resets_at))",
    "Updated \(ago(.updated_at)) | color=gray"
' "$file"
