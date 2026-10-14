#!/bin/sh
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# SwiftBar plugin (refreshes every minute): Claude plan limits left, from the numbers the Claude
# Code status line saves, and herdr agents that need you (blocked on input, or done).
jq=$(command -v jq || echo /opt/homebrew/bin/jq)
herdr=$(command -v herdr || echo /opt/homebrew/bin/herdr)
file="$HOME/.cache/claude-limits.json"

# herdr agents: empty when herdr isn't running.
agents=$("$herdr" agent list 2>/dev/null | "$jq" -c '.result.agents // []' 2>/dev/null)
[ -n "$agents" ] || agents='[]'

if [ -f "$file" ]; then limits=$(cat "$file"); else limits='null'; fi

# shellcheck disable=SC2016 # jq expressions, not shell
"$jq" -rn --argjson l "$limits" --argjson a "$agents" --arg herdr "$herdr" '
  def until(t): (t - now) as $s
    | if t == null or $s <= 0 then "now"
      elif $s >= 86400 then "\($s / 86400 | round) days"
      elif $s >= 3600 then "\($s / 3600 | round) h"
      else "\([$s / 60 | round, 1] | max) min" end;
  def ago(t): ((now - t) / 60 | round) as $m
    | if $m < 1 then "just now" elif $m < 60 then "\($m) min ago" else "\($m / 60 | round) h ago" end;
  def name_and_dir: "\(.name // .display_agent // .agent) · \(.cwd // "" | split("/") | last)";
  ([$a[] | select(.agent_status == "blocked")]) as $blocked
  | ([$a[] | select(.agent_status == "done")]) as $done
  | (if $l == null then "✻ –" else "✻ \($l.five_hour_left)%" end) as $limit
  | (if ($blocked | length) > 0 then " · ⏸\($blocked | length)" else "" end) as $waiting
  | (if $l != null and $l.five_hour_left < 20 then " | color=#d97757" else "" end) as $warn
  | "\($limit)\($waiting)\($warn)",
    "---",
    (if $l == null then "Open a Claude Code session to load your limits"
     else
       "5 hours: \($l.five_hour_left)% left · resets in \(until($l.five_hour_resets_at))",
       "Weekly: \($l.seven_day_left)% left · resets in \(until($l.seven_day_resets_at))",
       "Updated \(ago($l.updated_at)) | color=gray"
     end),
    (if ($blocked | length) + ($done | length) > 0 then
       "---",
       ($blocked[] | "⏸ \(name_and_dir) | bash=\($herdr) param1=agent param2=focus param3=\(.pane_id) terminal=false"),
       ($done[] | "✓ \(name_and_dir) | bash=\($herdr) param1=agent param2=focus param3=\(.pane_id) terminal=false")
     else empty end)
'
