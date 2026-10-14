#!/bin/sh
# Claude Code status line: model, directory, context use and plan limits left. Also saves the
# limits to ~/.cache/claude-limits.json for the desktop card (Übersicht widget). Local only.
input=$(cat)
jq=$(command -v jq || echo /opt/homebrew/bin/jq)

limits=$(printf '%s' "$input" | "$jq" -c '.rate_limits // empty
  | select(.five_hour or .seven_day)
  | {five_hour_left: (100 - (.five_hour.used_percentage // 0) | floor),
     five_hour_resets_at: .five_hour.resets_at,
     seven_day_left: (100 - (.seven_day.used_percentage // 0) | floor),
     seven_day_resets_at: .seven_day.resets_at,
     updated_at: now | floor}')
if [ -n "$limits" ]; then
	mkdir -p "$HOME/.cache"
	printf '%s\n' "$limits" >"$HOME/.cache/claude-limits.json.tmp" &&
		mv "$HOME/.cache/claude-limits.json.tmp" "$HOME/.cache/claude-limits.json"
fi

printf '%s' "$input" | "$jq" -r '[
  .model.display_name,
  (.workspace.current_dir // .cwd // "" | split("/") | last),
  "ctx \(.context_window.used_percentage // 0 | floor)%",
  (if .rate_limits.five_hour then "5h \(100 - .rate_limits.five_hour.used_percentage | floor)% left" else empty end),
  (if .rate_limits.seven_day then "week \(100 - .rate_limits.seven_day.used_percentage | floor)% left" else empty end)
] | map(select(. != null and . != "")) | join(" · ")'
