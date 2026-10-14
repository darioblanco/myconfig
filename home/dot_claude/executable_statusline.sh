#!/bin/sh
# Claude Code status line: model, directory, context use and how much of the 5-hour and weekly
# plan limits is left.
jq=$(command -v jq || echo /opt/homebrew/bin/jq)
"$jq" -r '[
  .model.display_name,
  (.workspace.current_dir // .cwd // "" | split("/") | last),
  "ctx \(.context_window.used_percentage // 0 | floor)%",
  (if .rate_limits.five_hour then "5h \(100 - .rate_limits.five_hour.used_percentage | floor)% left" else empty end),
  (if .rate_limits.seven_day then "week \(100 - .rate_limits.seven_day.used_percentage | floor)% left" else empty end)
] | map(select(. != null and . != "")) | join(" · ")'
